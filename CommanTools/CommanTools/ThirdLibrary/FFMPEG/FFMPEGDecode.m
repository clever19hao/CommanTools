//
//  FFMPEGDecode.m
//  FFMPEGDecode
//
//  Created by 钟发军 on 17/1/12.
//  Copyright © 2017年 Hubsan. All rights reserved.
//


#import "FFMPEGDecode.h"
#import "libavcodec/avcodec.h"
#import "libswscale/swscale.h"
#define VEDIOOUTPUTWIDTH 1920
#define VEDIOOUTPUTHEIGHT 1080
#define NalBufLength 209800  //40980
#define buffOutLength 1382400  //115200

//不限格式
#import "avformat.h"
#import "avcodec.h"
#import "avio.h"
#import "swscale.h"
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "Utilities.h"

@interface FFMPEGDecode ()

@end

@implementation FFMPEGDecode
{
    char rgbBuf[1920*1080*3];
    NSData *startcodeData;
    NSData *lastStartCode;
    AVFrame *frame;
    AVCodec *H264codec;
    AVCodecContext *codecCtx;
    AVPacket H264packet;
    int *H264frameFinished;
    NSMutableData *keyFrame;
    int VediooutputWidth;
    int VediooutputHeight;
    float Width;
    float Height;
    int iTemp;
    int nalLen;
    int NalBufUsed;
    bool bFirst;
    bool bFindPPS;
    char  NalBuf[NalBufLength]; // 40980
    char  buffOut[buffOutLength];//115200  460800
    char *buffOut2;
    int outSize, NWidth, NHeight;
    int mTrans;
    AVCodecParserContext *avParserContext;
    int SockBufUsed;
    int bytesRead;
}

- (id)init_code
{
    self = [super init];
    if (self) {
        mTrans=0x0F0F0F0F;
        iTemp = 0;
        nalLen = 0;
        NalBufUsed = 0;
        bFirst = true;
        bFindPPS = true;
        outSize = buffOutLength;//115200
        SockBufUsed = 0;
        bytesRead = 0;
        avcodec_register_all();
        av_init_packet(&(H264packet));
        frame = av_frame_alloc();
        H264codec = avcodec_find_decoder(AV_CODEC_ID_H264);
        codecCtx = avcodec_alloc_context3(H264codec);
        
//        avParserContext = av_parser_init( CODEC_ID_H264 );
        avParserContext = av_parser_init( AV_CODEC_ID_H264 );
        
        codecCtx->thread_count = 0;
        codecCtx->thread_type &= ~FF_THREAD_FRAME;
        AVDictionary *d = NULL;
        av_dict_set(&d, "threads", "auto", 0);
        
        int ret = avcodec_open2(codecCtx, H264codec, &d);
        if (ret != 0){
            NSLog(@"open codec failed :%d",ret);
        }else{
            NSLog(@"open codec succes :%d",ret);
        }
        
        av_dict_free(&d);
        
        keyFrame = [[NSMutableData alloc]init];
        
        VediooutputWidth = VEDIOOUTPUTWIDTH;
        VediooutputHeight = VEDIOOUTPUTHEIGHT;
        
//        unsigned char startcode[] = {0,0,0,1};
//        startcodeData = [NSData dataWithBytes:startcode length:4];
        //        [self openVedioUDPServer];
        
        
    }
    return self;
}

-(void)DecodeH264Data:(NSData *)data
{
    char  SockBuf[data.length];
    memset(SockBuf,0,data.length);
    memset(buffOut,0,buffOutLength); //115200
    bytesRead = (int)data.length;
    Byte *testByte2 = (Byte *)[data bytes];
    SockBufUsed = 0;
    while (bytesRead - SockBufUsed > 0) {
        nalLen = [self MergeBufferWithNalBuf:NalBuf andNalBufUsed:NalBufUsed andSockBuf:(char*)testByte2 andSockBufUsed:SockBufUsed andSockRemain:bytesRead-SockBufUsed];
        NalBufUsed += nalLen;
        SockBufUsed += nalLen;
        while(mTrans == 1)
        {
            mTrans = 0xFFFFFFFF;
            if(bFirst==true) // the first start flag
            {
                bFirst = false;
            }else{
                if(bFindPPS==true) // true
                {
                    if( (NalBuf[4]&0x1F) == 7)
                    {
                        bFindPPS = false;
                    }else{
                        NalBuf[0]=0;
                        NalBuf[1]=0;
                        NalBuf[2]=0;
                        NalBuf[3]=1;
                        NalBufUsed=4;
                        break;
                    }
                }
                [self VideoDecoder_Decode:(uint8_t*)NalBuf Length:NalBufUsed OutPut:(uint8_t*)buffOut OutSize:outSize width:&NWidth height:&NHeight];
            }
            NalBuf[0]=0;
            NalBuf[1]=0;
            NalBuf[2]=0;
            NalBuf[3]=1;
            NalBufUsed=4;
        }
    }
}

-(int)MergeBufferWithNalBuf:(char*)nalBuf andNalBufUsed:(int)nalBufUsed andSockBuf:(char*)SockBuf andSockBufUsed:(int)sockBufUsed andSockRemain:(int)SockRemain
{//把读取的数剧分割成NAL块
    int  i=0;
    char Temp;
    for(i=0; i<SockRemain; i++)
    {
        Temp  =SockBuf[i+sockBufUsed];
        nalBuf[i+nalBufUsed]=Temp;
        mTrans <<= 8;
        mTrans  |= Temp;
        if(mTrans == 1) // 找到一个开始字
        {
            i++;
            break;
        }
    }
    return i;
}

//使用av_parser_parse2分离数据帧试用于任何形式的数据裸流
-(void)StartSearchFrameHeardAndDecodeWithH264Data:(NSData *)data
{
    Byte *testByte2 = (Byte *)[data bytes];
    
    unsigned char *p;
    p = testByte2;
    unsigned char* buf = 0;
    int buf_len = 0;
    while (testByte2 +data.length - p > 0) {
        int len = av_parser_parse2(
                                   avParserContext, codecCtx,
                                   &buf, &buf_len,
                                   p , testByte2+(int)data.length-p ,
                                   0, 0, 0);
        p += len;
        
        if (buf_len) {
            memset(buffOut,0,buffOutLength);
            [self VideoDecoder_Decode:(uint8_t*)buf Length:buf_len OutPut:(uint8_t*)buffOut OutSize:outSize width:&NWidth height:&NHeight];
        }
    }
}

-(int)VideoDecoder_Decode:(uint8_t *)pDataIn Length:(int)nInSize OutPut:(uint8_t *)pDataOut OutSize:(int)nOutSize width:(int *)nWidth height:(int *)nHeight
{
    //    @synchronized(self) {
    H264packet.size = nInSize;
    H264packet.data = pDataIn;
    //    NSLog(@"packet.size: %d",packet.size);
    //    NSData *data = [NSData dataWithBytes:pDataIn length:nInSize];
    //    NSLog(@"data: %@",data);
    while (H264packet.size > 0) {
        int decodeLen = avcodec_decode_video2(codecCtx, frame, &H264frameFinished, &H264packet);
        if(decodeLen <= 0){
            //                        NSLog(@"decodeLen: %d",decodeLen);
            //            NSLog(@"解码失败");
            break;//解码失败
        }
        H264packet.size -= decodeLen;
        H264packet.data += decodeLen;
        if (H264frameFinished >0) {//解码成功
            //            NSLog(@"解码成功");
            fflush(stdout);
            *nWidth = codecCtx->width;
            *nHeight = codecCtx->height;
            //            NSLog(@"nOutSize: %d",nOutSize);
            if(nOutSize >= (codecCtx->width)*(codecCtx->height)*3/2)
            {
                pgm_save2(frame->data[0], frame->linesize[0],codecCtx->width, codecCtx->height,pDataOut);
                pgm_save2(frame->data[1], frame->linesize[1],codecCtx->width/2, codecCtx->height/2,pDataOut +codecCtx->width * codecCtx->height);
                pgm_save2(frame->data[2], frame->linesize[2],codecCtx->width/2, codecCtx->height/2,pDataOut +codecCtx->width * codecCtx->height*5/4);
            }
            if (H264packet.data) {
                H264packet.size -= decodeLen;
                H264packet.data += decodeLen;
            }
//            avpicture_get_size(PIX_FMT_RGB24, codecCtx->width, codecCtx->height);  //PIX_FMT_RGB24
            avpicture_get_size(AV_PIX_FMT_RGB24, codecCtx->width, codecCtx->height);  //PIX_FMT_RGB24
            
            [self YUV420ConvertToRGB:frame];
        }
    }
    //    NSLog(@"codecCtx->width: %d       codecCtx->height: %d",codecCtx->width,codecCtx->height);
    //    NSLog(@"frame->data[0]: %s",frame->data[1]);
    
//    if(nOutSize < (codecCtx->width)*(codecCtx->height)*3/2)
//    {
//        return -1;
//    }
    
//    [self YUV420ConvertToRGB:frame];
    
    return 0;
    //    }
    
}

void pgm_save2(unsigned char *buf,int wrap, int xsize,int ysize,uint8_t *pDataOut)
{
    int i;
    for(i=0;i<ysize;i++)
    {
        memcpy(pDataOut+i*xsize, buf + /*(ysize-i)*/i * wrap, xsize);
    }
    
}

- (void)YUV420ConvertToRGB:(AVFrame*)pict
{
    
    float width = frame->width;
    float height = frame->height;
    //===================把yuv帧数据转为rgb===========
    //    unsigned char *rgbBuf = malloc(width*height*3);
    char *buf = rgbBuf;
    
    struct SwsContext* img_convert = 0;
    int linesize[4] = {3*width, 0, 0, 0};
    
//    img_convert = sws_getContext(width, height,PIX_FMT_YUV420P,width,height,PIX_FMT_RGB24, SWS_BICUBIC, NULL, NULL, NULL);
    img_convert = sws_getContext(width, height,AV_PIX_FMT_YUV420P,width,height,AV_PIX_FMT_RGB24, SWS_BICUBIC, NULL, NULL, NULL);
    if (img_convert != 0)
    {
        sws_scale(img_convert, (const uint8_t* const*)pict->data, pict->linesize, 0, height, (uint8_t**)&buf, linesize);
        sws_freeContext(img_convert);
        
        //        NSData *data = [NSData dataWithBytes:rgbBuf length:width*height*3];
        //        free(rgbBuf);
        //        [self testwithdata:data];
        //生成图片
        [self saveFrame:buf length:width * height * 3 nWidth:width nHeight:height];
        [self.RGBDelegate UpdateRGBBuf:buf length:width * height * 3 nWidth:width nHeight:height];
    }
}

-(int)VideoWidth
{
    return frame->width;
}

-(int)VideoHight
{
    return frame->height;
}

-(void)dealloc{
    // Free the packet that was allocated by av_read_frame
    av_free_packet(&H264packet);
    
    // Free the YUV frame
    av_free(frame);
    
    // Close the codec
    if (codecCtx) avcodec_close(codecCtx);
    av_parser_close(avParserContext);
}

- (void)saveFrame: (unsigned char*)pFrameRGB length:(int)len nWidth:(int)nWidth nHeight:(int)nHeight
{
    if(len > 0)
    {
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//        CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pFrameRGB, nWidth*nHeight*3,kCFAllocatorNull);
        CFDataRef data = CFDataCreate(kCFAllocatorDefault, pFrameRGB, nWidth*nHeight*3);
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef cgImage = CGImageCreate(nWidth,
                                           nHeight,
                                           8,
                                           24,
                                           nWidth*3,
                                           colorSpace,
                                           bitmapInfo,
                                           provider,
                                           NULL,
                                           YES,
                                           kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        UIImage* image = [[UIImage alloc]initWithCGImage:cgImage];   //crespo modify 20111020
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CFRelease(data);
        if (!image) {
            
        }
        [self.delegate DisplayNewScreen:image];
    }
}
@end
