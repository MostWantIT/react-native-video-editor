//
//  VideoMergeUtil.m
//  RCTVideoEditor
//
//  Created by Michel Antonides on 28-10-16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "VideoMergeUtil.h"

@implementation VideoMergeUtil

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

// Persist data
RCT_EXPORT_METHOD(merge:(NSArray *)fileNames
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback) {
  
  NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
  
  [self MergeVideo:fileNames callback:successCallback];
  
  //successCallback(@[@"merge video", fileNames[0]]);
}

-(void)LoopVideo:(NSArray *)fileNames
{
  for (id object in fileNames)
  {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video1" ofType:@"mov"];
    NSLog(@"video: %@", path);
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:object]];
    NSLog(@"Assset: %@", [asset tracksWithMediaType:AVMediaTypeVideo]);
  }
}

-(void)MergeVideo:(NSArray *)fileNames callback:(RCTResponseSenderBlock)successCallback
{
  
  CGFloat totalDuration;
  totalDuration = 0;
  
  AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
  
  AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                      preferredTrackID:kCMPersistentTrackID_Invalid];
  
  AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                      preferredTrackID:kCMPersistentTrackID_Invalid];
  
  CMTime insertTime = kCMTimeZero;
  
  for (id object in fileNames)
  {
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:object]];
    
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    [videoTrack insertTimeRange:timeRange
                        ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:insertTime
                          error:nil];
    
    [audioTrack insertTimeRange:timeRange
                        ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:insertTime
                          error:nil];
    
    insertTime = CMTimeAdd(insertTime,asset.duration);
  }
  
  CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI_2);
  videoTrack.preferredTransform = rotationTransform;
  
  NSString* documentsDirectory= [self applicationDocumentsDirectory];
  NSString * myDocumentPath = [documentsDirectory stringByAppendingPathComponent:@"merge_video.mp4"];
  NSURL * urlVideoMain = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
  
  if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
  {
    [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
  }
  
  AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
  exporter.outputURL = urlVideoMain;
  exporter.outputFileType = @"com.apple.quicktime-movie";
  exporter.shouldOptimizeForNetworkUse = YES;
  
  [exporter exportAsynchronouslyWithCompletionHandler:^{
    
    switch ([exporter status])
    {
      case AVAssetExportSessionStatusFailed:
        break;
        
      case AVAssetExportSessionStatusCancelled:
        break;
        
      case AVAssetExportSessionStatusCompleted:
        successCallback(@[@"merge video complete", myDocumentPath]);
        break;
        
      default:
        break;
    }
  }];
}

- (NSString*) applicationDocumentsDirectory
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}


@end
