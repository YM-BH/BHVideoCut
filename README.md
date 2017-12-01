## BHVideoCut

### 只需调用一个方法 即可完成视频的剪辑

获取本地视频和裁剪的方法，都放在VideoManager类

```
/**
获取视频列表

@return 模型数组
*/
+ (NSArray *)getVideoList;

```

```
/**
获取视频封面图

@param asset PHAsset
@param size 大小
@param completion 回调image
*/
+ (void)getVideoPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(videoImgBlock)completion;

```

```
/**
获取 AVURLAsset

@param asset PHAsset
@param completion 回调urlAsset
*/
+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion;

```

```
/**
根据时间裁剪

@param avAsset avAsset
@param startTime 起始时间
@param endTime 结束时间
@param completion 回调视频url
*/
+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(outputBlock)completion;
```
