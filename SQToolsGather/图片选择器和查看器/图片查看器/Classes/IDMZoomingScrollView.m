//
//  IDMZoomingScrollView.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "IDMZoomingScrollView.h"
#import "IDMPhotoBrowser.h"
#import "IDMPhoto.h"
#import "SDImageCache.h"
#import "YYCache.h"
#import "YYWebImage.h"
// Declare private methods of browser
@interface IDMPhotoBrowser ()
- (UIImage *)imageForPhoto:(id<IDMPhoto>)photo;
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)toggleControls;
@end

// Private methods and properties
@interface IDMZoomingScrollView ()
@property (nonatomic, weak) IDMPhotoBrowser *photoBrowser;
- (void)handleSingleTap:(CGPoint)touchPoint;
- (void)handleDoubleTap:(CGPoint)touchPoint;
@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,assign)BOOL isLongImage;
@end

@implementation IDMZoomingScrollView

@synthesize photoImageView = _photoImageView, photoBrowser = _photoBrowser, photo = _photo, captionView = _captionView;

- (id)initWithPhotoBrowser:(IDMPhotoBrowser *)browser {
    if ((self = [super init])) {
        // Delegate
        self.photoBrowser = browser;
        
        // Tap view for background
        _tapView = [[IDMTapDetectingView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        
        // Image view
        _photoImageView = [[IDMTapDetectingImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.tapDelegate = self;
        _photoImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_photoImageView];
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeIDMphoto:)];
        singleTap.numberOfTapsRequired = 1;
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleIDMphoto:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [self addGestureRecognizer:singleTap];
        [self addGestureRecognizer:doubleTap];
        
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenBound.size.width;
        CGFloat screenHeight = screenBound.size.height;
        
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
            [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            screenWidth = screenBound.size.height;
            screenHeight = screenBound.size.width;
        }
        
        // Progress view
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake((screenWidth-35.)/2., (screenHeight-35.)/2, 35.0f, 35.0f)];
        [_progressView setProgress:0.0f];
        _progressView.tag = 101;
        _progressView.thicknessRatio = 0.1;
        _progressView.roundedCorners = NO;
        _progressView.trackTintColor    = browser.trackTintColor    ? self.photoBrowser.trackTintColor    : [UIColor colorWithWhite:0.2 alpha:1];
        _progressView.progressTintColor = browser.progressTintColor ? self.photoBrowser.progressTintColor : [UIColor colorWithWhite:1.0 alpha:1];
        [self addSubview:_progressView];
        
        // Setup
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}
-(void)savePhoto:(UIButton *)btn{
    
    UIImageWriteToSavedPhotosAlbum(self.photoImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    
    if (error) {
        //        NSLog(@"保存失败");
    }   else {
        //        NSLog(@"保存成功");
    }
    
}
//-(void)seePhoto:(UIButton *)btn{
//
//    if (_btnBlock) {
//        _btnBlock();
//    }
//    btn.hidden = YES;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/item/201506/20/20150620125811_cwShx.thumb.700_0.jpeg"]];
//
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    op.responseSerializer = [AFImageResponseSerializer serializer];
//
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        UIImage *img = responseObject;
//        _photoImageView.image = img;
//        CGRect photoImageViewFrame;
//        photoImageViewFrame.origin = CGPointZero;
//        photoImageViewFrame.size = img.size;
//        _photoImageView.frame = photoImageViewFrame;
//        self.contentSize = photoImageViewFrame.size;
//        [self setMaxMinZoomScalesForCurrentBounds];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { }];
//
//    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
////        CGFloat progress = ((CGFloat)totalBytesRead)/((CGFloat)totalBytesExpectedToRead);
////        if (self.progressUpdateBlock) {
////            self.progressUpdateBlock(progress);
////        }
//    }];
//
//    [[NSOperationQueue mainQueue] addOperation:op];
//
////    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/item/201506/20/20150620125811_cwShx.thumb.700_0.jpeg"] placeholderImage:_photoImageView.image];
//
//}
- (void)setPhoto:(id<IDMPhoto>)photo {
    IDMPhoto *currentPhoto = (IDMPhoto *)photo;

    if (!currentPhoto.isCheckOriginalImage) {
        _photoImageView.image = nil; // Release image
    }
    if (_photo != photo) {
        _photo = photo;
    }
    [self displayImage];
}

- (void)prepareForReuse {
    self.photo = nil;
    [_captionView removeFromSuperview];
    self.captionView = nil;
}

#pragma mark - Image

// Get and display image
- (void)displayImage {
    IDMPhoto *currentPhoto = (IDMPhoto *)_photo;

    _seePhooButton.hidden = YES;
    _saveBtn.hidden = YES;
    
    if ((_photo && _photoImageView.image == nil)||(_photo && _photoImageView.image && currentPhoto.isCheckOriginalImage)||(_photo && _photoImageView.image && currentPhoto.isWifiLoadOriginalImage)) {
        // Reset
        
        if (!currentPhoto.isCheckOriginalImage) {
            self.maximumZoomScale = 1;
            self.minimumZoomScale = 1;
            self.zoomScale = 1;
            
            self.contentSize = CGSizeMake(0, 0);
        }
        
        // Get image from browser as it handles ordering of fetching
        UIImage *img = [self.photoBrowser imageForPhoto:_photo];
        
        if (img) {
            
            // Hide ProgressView
            //_progressView.alpha = 0.0f;
            [_progressView removeFromSuperview];
            
            
            // Set image
            _photoImageView.image = img;
            _photoImageView.hidden = NO;
            _seePhooButton.hidden = NO;
            _saveBtn.hidden = NO;
            // Setup photo frame
            CGRect photoImageViewFrame;
            photoImageViewFrame.origin = CGPointZero;
            
            CGSize size_;
            if (img.size.width<=[UIScreen mainScreen].bounds.size.width) {
                size_.width = [UIScreen mainScreen].bounds.size.width;
                size_.height = ([UIScreen mainScreen].bounds.size.width)*img.size.height/img.size.width;
            }else{
            
                size_ = img.size;
            }
            photoImageViewFrame.size = size_;
            
            _photoImageView.frame = photoImageViewFrame;
            _seePhooButton.frame = CGRectMake(25, self.frame.size.height - 56, 55, 26);
            _saveBtn.frame = CGRectMake(self.frame.size.width - 75, self.frame.size.height - 56, 55, 26);
            self.contentSize = photoImageViewFrame.size;
            
            // Set zoom to minimum zoom
            [self setMaxMinZoomScalesForCurrentBounds];
            
        } else {
            // Hide image view
           
            if(currentPhoto.isCheckOriginalImage){
                _photoImageView.hidden = NO;
                UIImage *currentImage_ = nil;

                YYImageCache *cache = [YYWebImageManager sharedManager].cache;
                UIImage *yyCurrentImage = [cache getImageForKey:[self _appendingString:[currentPhoto.photoURL absoluteString]] withType:YYImageCacheTypeAll];
                UIImage *memoryImage_sd = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[self _appendingString:[currentPhoto.photoURL absoluteString]]];
                UIImage *cacheImage_sd  = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self _appendingString:[currentPhoto.photoURL absoluteString]]];
                NSLog(@"---%@---",[currentPhoto.photoURL absoluteString]);
                NSLog(@"yyCurrentImage----%@---",yyCurrentImage);
                if(yyCurrentImage||memoryImage_sd||cacheImage_sd){
                    if (yyCurrentImage) {
                        currentImage_ = yyCurrentImage;
                    }else if(memoryImage_sd){
                        currentImage_ = memoryImage_sd;

                    }else if(cacheImage_sd){
                        currentImage_ = cacheImage_sd;

                    }
                }else{
                
                    currentImage_ = [UIImage imageNamed:@"zhanwei2"];

                }
                
                _photoImageView.hidden = NO;
                _photoImageView.image = currentImage_;
                
                CGRect photoImageViewFrame;
                photoImageViewFrame.origin = CGPointZero;
                
                CGSize size_;
                if (currentImage_.size.width<=[UIScreen mainScreen].bounds.size.width) {
                    size_.width = [UIScreen mainScreen].bounds.size.width;
                    size_.height = ([UIScreen mainScreen].bounds.size.width)*currentImage_.size.height/currentImage_.size.width;
                }else{
                    
                    size_ = currentImage_.size;
                }
                photoImageViewFrame.size = size_;
                
                _photoImageView.frame = photoImageViewFrame;
                _seePhooButton.frame = CGRectMake(25, self.frame.size.height - 56, 55, 26);
                _saveBtn.frame = CGRectMake(self.frame.size.width - 75, self.frame.size.height - 56, 55, 26);
                self.contentSize = photoImageViewFrame.size;
                
                // Set zoom to minimum zoom
                [self setMaxMinZoomScalesForCurrentBounds];


            }
            else {
                if (currentPhoto.isWifi) {
                    currentPhoto.isWifiLoadOriginalImage = YES;
                }else{
                    currentPhoto.isWifiLoadOriginalImage = NO;
                }
                UIImage *currentImage_ = nil;
                _photoImageView.hidden = NO;

                YYImageCache *cache = [YYWebImageManager sharedManager].cache;
                UIImage *yyCurrentImage = [cache getImageForKey:[self _gifAppendingString:[currentPhoto.photoURL absoluteString]] withType:YYImageCacheTypeAll];
                UIImage *memoryImage_sd = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[self _gifAppendingString:[currentPhoto.photoURL absoluteString]]];
                UIImage *cacheImage_sd  = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self _gifAppendingString:[currentPhoto.photoURL absoluteString]]];
                UIImage *memoryImage_sd_or = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self _judgeWebImageCache:[currentPhoto.photoURL absoluteString]]];
                UIImage *cacheImage_sd_or = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self _judgeWebImageCache:[currentPhoto.photoURL absoluteString]]];

                if (!currentPhoto.isWifiLoadOriginalImage) {// 非wifi环境下，如果获取到缓存图则直接显示

                    if (memoryImage_sd_or||cacheImage_sd_or) {// 原图
                        [_progressView removeFromSuperview];

                        if (memoryImage_sd_or) {
                            currentImage_ = memoryImage_sd_or;
                        }else if(cacheImage_sd_or){
                            currentImage_ = cacheImage_sd_or;
                        }
                    }else if(memoryImage_sd || cacheImage_sd||yyCurrentImage){// 缩略图

                        if (memoryImage_sd) {
                            currentImage_ = memoryImage_sd;

                        }else if(cacheImage_sd){
                            currentImage_ = cacheImage_sd;

                        }else if(yyCurrentImage){
                            currentImage_ = yyCurrentImage;
                        }
                        // 判断是否gif图片
                        if ([[currentPhoto.photoURL absoluteString] containsString:@".gif"]) {
                            currentPhoto.isWifiLoadOriginalImage = YES;
                        }else{
                            [_progressView removeFromSuperview];
                        }
                    }else{
                        currentPhoto.isWifiLoadOriginalImage = YES;
                    }
                    
                }
                else{
                
                    if(memoryImage_sd || cacheImage_sd||yyCurrentImage){// 缩略图
                        if (memoryImage_sd) {
                            currentImage_ = memoryImage_sd;
                            
                        }else if(cacheImage_sd){
                            currentImage_ = cacheImage_sd;
                            
                        }else if(yyCurrentImage){
                            currentImage_ = yyCurrentImage;
                        }
                        
                        // 判断是否gif图片
                        if ([[currentPhoto.photoURL absoluteString] containsString:@".gif"]) {
                            currentPhoto.isWifiLoadOriginalImage = YES;
                        }
                    }else{
                        currentPhoto.isWifiLoadOriginalImage = YES;
                    }
                }
                
                NSLog(@"---%@---",[currentPhoto.photoURL absoluteString]);
                NSLog(@"currentImage_----%@---",currentImage_);
                if(!currentImage_){
                    currentImage_ = [UIImage imageNamed:@"zhanwei2"];
                }
                
                _photoImageView.hidden = NO;
                _photoImageView.image = currentImage_;
                
                CGRect photoImageViewFrame;
                photoImageViewFrame.origin = CGPointZero;
                
                CGSize size_;
                if (currentImage_.size.width<=[UIScreen mainScreen].bounds.size.width) {
                    size_.width = [UIScreen mainScreen].bounds.size.width;
                    size_.height = ([UIScreen mainScreen].bounds.size.width)*currentImage_.size.height/currentImage_.size.width;
                }else{
                    
                    size_ = currentImage_.size;
                }
                photoImageViewFrame.size = size_;
                
                _photoImageView.frame = photoImageViewFrame;
                _seePhooButton.frame = CGRectMake(25, self.frame.size.height - 56, 55, 26);
                _saveBtn.frame = CGRectMake(self.frame.size.width - 75, self.frame.size.height - 56, 55, 26);
                self.contentSize = photoImageViewFrame.size;
                
                // Set zoom to minimum zoom
                [self setMaxMinZoomScalesForCurrentBounds];
            }
            

            _seePhooButton.hidden = YES;
            _saveBtn.hidden = YES;
            _progressView.alpha = 1.0f;
        }
        
        [self setNeedsLayout];
    }
}

- (NSString *)_appendingString:(NSString *)str{

    str = [str stringByAppendingString:@"@!m.jpg"];
    return str;
}

- (NSString *)_gifAppendingString:(NSString *)str{

    if ([str containsString:@".gif"]) {
        str = [str stringByAppendingString:@"@!m.jpg"];
    }
    return str;
}

- (NSString *)_judgeWebImageCache:(NSString *)WebImageUrl {
    
    NSArray *icoArr = @[@"@!ico_xl_2x",@"@!ico_m_2x",@"@!m.jpg"];
    
    for (NSString *key in icoArr) {
        if ([WebImageUrl rangeOfString:key].location != NSNotFound) {
            NSString *newUrl =[WebImageUrl substringToIndex:WebImageUrl.length - key.length];
                return newUrl;
        }
        
    }
    return WebImageUrl;
}



- (void)setProgress:(CGFloat)progress forPhoto:(IDMPhoto*)photo {
    IDMPhoto *p = (IDMPhoto*)self.photo;
    
    if ([photo.photoURL.absoluteString isEqualToString:p.photoURL.absoluteString]) {
        if (_progressView.progress < progress) {
            [_progressView setProgress:progress animated:YES];
        }
    }
}

- (void)resetProgress{
    [self addSubview:_progressView];

    [_progressView setProgress:0.0f];
}

// Image failed so just show black!
- (void)displayImageFailure {
    [_progressView removeFromSuperview];
}

#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail
    if (_photoImageView.image == nil) return;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // If image is smaller than the screen then ensure we show it at
    // min scale of 1
    if (xScale > 1 && yScale > 1) {
        //minScale = 1.0;
    }
    
    // Calculate Max
    CGFloat maxScale = 4.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    
    // Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    // Update tap view frame
    
    
    _tapView.frame = self.bounds;
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  
    return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_photoBrowser cancelControlHiding];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [_photoBrowser cancelControlHiding];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_photoBrowser hideControlsAfterDelay];
}

-(void)closeIDMphoto:(UITapGestureRecognizer *)recognizer{
    NSLog(@"%d",recognizer.numberOfTapsRequired);
    if (_clouseBlock) {
        _clouseBlock();
    }
}
-(void)DoubleIDMphoto:(UITapGestureRecognizer *)recognizer{
      
    [NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat imageWidth = _photoImageView.image.size.width;
    CGFloat imageHeight = _photoImageView.image.size.height;
    if (imageHeight * width / imageWidth > height + 100) {
        [self longImage];
        [_photoBrowser hideControlsAfterDelay];
        return;
    }
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        _seePhooButton.hidden = NO;
        _saveBtn.hidden = NO;
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        _seePhooButton.hidden = YES;
        _saveBtn.hidden = YES;
        // Zoom in
        //         self.zoomScale *2.0;
        CGFloat x = self.frame.size.width/2;
        CGFloat y = self.frame.size.height/2;
        
        x = self.contentSize.width > self.frame.size.width? self.contentSize.width/2: x;
        y = self.contentSize.height > self.frame.size.height? self.contentSize.height/2: y;
        
        //        [m_imageView setCenter:CGPointMake(x, y)];
        [self setZoomScale:self.maximumZoomScale animated:YES];
        //        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
        
    }
    
    // Delay controls
    [_photoBrowser hideControlsAfterDelay];
}
#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
//    [_photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    
    // Cancel any single tap handling
//    [NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
//    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat imageWidth = _photoImageView.image.size.width;
//    CGFloat imageHeight = _photoImageView.image.size.height;
//    if (imageHeight * width / imageWidth > height + 100) {
//         [self longImage];
//          [_photoBrowser hideControlsAfterDelay];
//        return;
//    }
//   
//    // Zoom
//    if (self.zoomScale == self.maximumZoomScale) {
//        _seePhooButton.hidden = NO;
//        _saveBtn.hidden = NO;
//        // Zoom out
//        [self setZoomScale:self.minimumZoomScale animated:YES];
//        
//    } else {
//        _seePhooButton.hidden = YES;
//        _saveBtn.hidden = YES;
//        // Zoom in
//        //         self.zoomScale *2.0;
//        CGFloat x = self.frame.size.width/2;
//        CGFloat y = self.frame.size.height/2;
//        
//        x = self.contentSize.width > self.frame.size.width? self.contentSize.width/2: x;
//        y = self.contentSize.height > self.frame.size.height? self.contentSize.height/2: y;
//        
//        //        [m_imageView setCenter:CGPointMake(x, y)];
//        [self setZoomScale:self.maximumZoomScale animated:YES];
//        //        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
//        
//    }
//    
//    // Delay controls
//    [_photoBrowser hideControlsAfterDelay];
}
-(void)longImage{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat imageWidth = _photoImageView.image.size.width;
    CGFloat imageHeight = _photoImageView.image.size.height;
    if (!_isLongImage) {
        [UIView animateWithDuration:0.3 animations:^{
            _photoImageView.frame = CGRectMake(0, 0, width, imageHeight * width / imageWidth);
        } completion:^(BOOL finished) {
            [self setZoomScale:0.01 animated:YES];
             _isLongImage = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
            _photoImageView.frame = CGRectMake((width*0.5 - imageWidth * height / imageHeight * 0.5), 0, imageWidth * height / imageHeight ,height );
        } completion:^(BOOL finished) {
            [self setZoomScale:0 animated:YES];
            _isLongImage = NO;
 
        }];
    }
    
}

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:view]];
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:view]];
}

@end
