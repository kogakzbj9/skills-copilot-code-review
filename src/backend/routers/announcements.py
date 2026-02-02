"""
Announcements endpoints for the High School Management System API
"""

from fastapi import APIRouter, HTTPException
from typing import Dict, Any, List
from datetime import datetime
from bson import ObjectId

from ..database import announcements_collection, teachers_collection

router = APIRouter(
    prefix="/announcements",
    tags=["announcements"]
)


@router.get("")
def get_announcements() -> List[Dict[str, Any]]:
    """Get all active announcements (not expired)"""
    current_time = datetime.utcnow().isoformat() + "Z"
    
    announcements = announcements_collection.find({
        "expiration_date": {"$gte": current_time}
    })
    
    result = []
    for announcement in announcements:
        # Check if announcement has started
        start_date = announcement.get("start_date")
        if start_date and start_date > current_time:
            continue
            
        announcement["id"] = str(announcement["_id"])
        del announcement["_id"]
        result.append(announcement)
    
    return result


@router.get("/all")
def get_all_announcements(username: str) -> List[Dict[str, Any]]:
    """Get all announcements including expired (requires authentication)"""
    # Verify user is authenticated
    teacher = teachers_collection.find_one({"_id": username})
    if not teacher:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    announcements = announcements_collection.find().sort("created_at", -1)
    
    result = []
    for announcement in announcements:
        announcement["id"] = str(announcement["_id"])
        del announcement["_id"]
        result.append(announcement)
    
    return result


@router.post("")
def create_announcement(
    username: str,
    message: str,
    expiration_date: str,
    start_date: str = None
) -> Dict[str, Any]:
    """Create a new announcement (requires authentication)"""
    # Verify user is authenticated
    teacher = teachers_collection.find_one({"_id": username})
    if not teacher:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # Validate expiration_date
    try:
        datetime.fromisoformat(expiration_date.replace("Z", "+00:00"))
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid expiration_date format")
    
    # Validate start_date if provided
    if start_date:
        try:
            datetime.fromisoformat(start_date.replace("Z", "+00:00"))
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid start_date format")
    
    announcement = {
        "message": message,
        "start_date": start_date,
        "expiration_date": expiration_date,
        "created_by": username,
        "created_at": datetime.utcnow().isoformat() + "Z"
    }
    
    result = announcements_collection.insert_one(announcement)
    announcement["id"] = str(result.inserted_id)
    
    return announcement


@router.put("/{announcement_id}")
def update_announcement(
    announcement_id: str,
    username: str,
    message: str = None,
    expiration_date: str = None,
    start_date: str = None
) -> Dict[str, Any]:
    """Update an existing announcement (requires authentication)"""
    # Verify user is authenticated
    teacher = teachers_collection.find_one({"_id": username})
    if not teacher:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # Validate ObjectId
    try:
        obj_id = ObjectId(announcement_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid announcement ID")
    
    # Find existing announcement
    announcement = announcements_collection.find_one({"_id": obj_id})
    if not announcement:
        raise HTTPException(status_code=404, detail="Announcement not found")
    
    # Build update document
    update_doc = {}
    if message is not None:
        update_doc["message"] = message
    if expiration_date is not None:
        if expiration_date == "":
            # Treat empty string as a request to clear the expiration date
            update_doc["expiration_date"] = None
        else:
            try:
                datetime.fromisoformat(expiration_date.replace("Z", "+00:00"))
                update_doc["expiration_date"] = expiration_date
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid expiration_date format")
    if start_date is not None:
        if start_date == "":
            # Treat empty string as a request to clear the start date
            update_doc["start_date"] = None
        else:
            try:
                datetime.fromisoformat(start_date.replace("Z", "+00:00"))
                update_doc["start_date"] = start_date
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid start_date format")
    
    if update_doc:
        announcements_collection.update_one(
            {"_id": obj_id},
            {"$set": update_doc}
        )
    
    # Return updated announcement
    updated_announcement = announcements_collection.find_one({"_id": obj_id})
    updated_announcement["id"] = str(updated_announcement["_id"])
    del updated_announcement["_id"]
    
    return updated_announcement


@router.delete("/{announcement_id}")
def delete_announcement(announcement_id: str, username: str) -> Dict[str, str]:
    """Delete an announcement (requires authentication)"""
    # Verify user is authenticated
    teacher = teachers_collection.find_one({"_id": username})
    if not teacher:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # Validate ObjectId
    try:
        obj_id = ObjectId(announcement_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid announcement ID")
    
    # Delete the announcement
    result = announcements_collection.delete_one({"_id": obj_id})
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Announcement not found")
    
    return {"message": "Announcement deleted successfully"}
