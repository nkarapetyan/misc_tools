"""
For reordering Gopro files from CAMERA_NAME/DATE_STAMP/*.mp4 to DATE_STAMP/CAMERA_NAME/*.mp4

HOW TO USE: call reorder_dirs

File name: gopro_cleanup.py
Author: Nare Karapetyan
Licence: 
Date Created: Sept 17 2020
Date Last Modified: Sept 17 2020

"""
import os
import shutil
import cv2

def move_to(fileName, dst):
    shutil.move(fileName, dst)
    print("calls the move_to")
    return

def is_corrupted(fileName):
    print("calls is_corrupted")
    try:
        vid = cv2.VideoCapture(fileName)
        if not vid.isOpened():
            return True
    except cv2.error as e:
        return True
    except Exception as e:
        return True
    return False

def move_files(srcDir, dstDir):
    """
    Moves files from srcDir to dstDir:
     - if file is corrupted in srcDir does nothing (maybe later can delete it or move to local trash)
     - if file exists in dstDir and it is not corrupted then srcDir file will be removed
    """
    print(srcDir)
    for fileName in os.listdir(srcDir):
        print(fileName)
        if is_corrupted(srcDir + "/" + fileName):
            #maybe better to manually check before removing
            #os.remove(srcDir + "/" + fileName)
            continue
        if os.path.isfile(dstDir + "/" + fileName) and not is_corrupted(dstDir + "/" + fileName):
            os.remove(srcDir + "/" + fileName)
            continue
        move_to(srcDir + "/" + fileName, dstDir)

def revert_back(srcRootDir, dstRootDir):
    """
    Just for testing purposes to revert the changes and test again
    """
    reorder_dirs(dstRootDir, srcRootDir)

def reorder_dirs(srcRootDir, dstRootDir):
    """
    Takes srcDir that contains CAMERA/DATE_STAMP with gopro files and moves them in dstDir that
    has DATE_STAMP/CAMERA subdirs 

    Parameters
    ----------
        srcRootDir : the root dir of location of file , must contain CAMERA/DATE_STAMP subdirs
        dstRootDir : the destination dir to move files with DATE_STAMP/CAMERA subdirs
    Example:
    --------
    reorder_dirs("/home/user/Gopro", "/home/user/dstGopro")

    """

    if not os.path.exists(srcRootDir):
        print("The source Directory does not exists")
        return

    if not os.path.exists(dstRootDir):
        print("The Destination Directory does not exists")
        return

    cam_list = next(os.walk(srcRootDir))[1]
    for curr_cam in cam_list:
        date_list = next(os.walk(srcRootDir + "/" + curr_cam))[1]
        for curr_date in date_list:
            if not os.path.exists(dstRootDir + "/" + curr_date + "/" + curr_cam):
                os.makedirs(dstRootDir + "/" + curr_date + "/" + curr_cam)
            srcDir = srcRootDir + "/" + curr_cam + "/" + curr_date
            dstDir = dstRootDir + "/" + curr_date + "/" + curr_cam
            move_files(srcDir, dstDir)

            #check if srdDir does not contain any files then delete it
            if os.listdir(srcDir) == []:
                os.rmdir(srcDir)


        #check if srdDir does not contain any files then delete it
        if os.listdir(srcRootDir + "/" + curr_cam) == []:
            os.rmdir(srcRootDir + "/" + curr_cam)



#srcDir = "/home/nare/wsp/data_organizer/srcDir"
#dstDir = "/home/nare/wsp/data_organizer/dstDir"

srcDir = input("Type the Source Directory of Gopro Images to be moved:")
dstDir = input("Type the Destination Directory to save images:")

revert_back(srcDir, dstDir)
#reorder_dirs(srcDir, dstDir)
