//
//  ServerApi.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/5.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "ServerApi.h"
#import "NSError+Custom.h"

#define HTTP_CONTENT_BOUNDARY @"###############BOUNDARY##################"

/*
 Http Header里的Content-Type一般有这三种：
 application/x-www-form-urlencoded：数据被编码为名称/值对。这是标准的编码格式。
 multipart/form-data： 数据被编码为一条消息，页上的每个控件对应消息中的一个部分。
 text/plain： 数据以纯文本形式(text/json/xml/html)进行编码，其中不含任何控件或格式字符。
 application/json
 */
@implementation ServerApi

+ (ServerApi *)getServerApi {
    
    static ServerApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!api) {
            api = [[ServerApi alloc] init];
            
            [api initWithConfig:ServerConfig.defaultConfig];
        }
    });
    return api;
}

- (void)initWithConfig:(ServerConfig *)config {
    
    _config = config;
}

- (void)test {
    
//    [self postRequestWithUrl:@"http://192.168.0.88/hubtv/index/getsts" param:@{@"username":@"cxq"} response:^(NSDictionary *result, NSError *error) {
//    }];
    
//    [self postRequestWithUrl:@"http://192.168.0.88/hubtv/index/getsts" formParam:@{@"username":@"cxq"} formField:@[@{@"name":@"img",@"filename":@"111.jpg",@"mime":@"image/jpeg"}] response:^(NSDictionary *result, NSError *error) {
//
//    }];
    
    
}

//标准POST请求
- (void)postRequestWithUrl:(NSString *)url param:(NSDictionary *)param response:(void (^)(NSDictionary *result,NSError *error))complete {
    
    if (url.length <= 0 || param == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (complete) {
                complete(nil,[ServerApi serverError:CodeParamIsNil]);
            }
        });
        return;
    }
    
    NSMutableDictionary *allParam = [_config configParam];
    if (!allParam) {
        allParam = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [allParam addEntriesFromDictionary:param];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:30];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet;
    
    NSMutableArray *paramStrArray = [NSMutableArray arrayWithCapacity:1];
    for (NSString *key in [allParam allKeys]) {
        NSString *value = allParam[key];
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:character];
        NSString *key_value_str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStrArray addObject:key_value_str];
    }
    
    NSString *postStr = [paramStrArray componentsJoinedByString:@"&"];
    [req setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    S_DBG(@"请求url:%@\n参数:%@", url,allParam);
    [self postRequest:req jsonResponse:^(NSDictionary *result, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(result,error);
            }
        });
    }];
}

- (void)postRequestWithUrl:(NSString *)url
                 formParam:(NSDictionary *)param
                 formField:(NSArray <NSDictionary *> *)fieldArray
                  response:(void (^)(NSDictionary *result,NSError *error))complete {
    
    if (url.length <= 0 || (param == nil && [fieldArray count] == 0)) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (complete) {
                complete(nil,[ServerApi serverError:CodeParamIsNil]);
            }
        });
        return;
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:60];
    [req setHTTPMethod:@"POST"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",HTTP_CONTENT_BOUNDARY]  forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *allParam = [_config configParam];
    if (!allParam) {
        allParam = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [allParam addEntriesFromDictionary:param];
    
    NSCharacterSet *character = [NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet;
    
    NSMutableData *postData = [NSMutableData data];
    for (NSString *key in [allParam allKeys]) {
        
        NSString *value = allParam[key];
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:character];
        
        NSString *key_value_str = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",HTTP_CONTENT_BOUNDARY,key,allParam[key]];
        
        [postData appendData:[key_value_str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (NSDictionary *field in fieldArray) {
        
        NSString *name = field[@"name"] ?: @"file";
        NSString *filename = field[@"filename"] ?: @"default.data";
        NSString *mime = field[@"mime"] ?: @"application/octet-stream";
        NSData *data = field[@"filedata"];
        
        NSString *key_str = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=\"%@\";Content-Type=\"%@\"\r\n\r\n",HTTP_CONTENT_BOUNDARY,name,filename,mime];
        printf("%s",[key_str UTF8String]);
        [postData appendData:[key_str dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (data) {
            [postData appendData:data];
        }
        printf("data长度%d",(int)data.length);
        
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        printf("\r\n");
    }
    
    NSString *end = [NSString stringWithFormat:@"--%@--\r\n",HTTP_CONTENT_BOUNDARY];
    printf("%s",[end UTF8String]);
    [postData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    req.HTTPBody = postData;
    [req setValue:[NSString stringWithFormat:@"%d",(int)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    S_DBG(@"请求url:%@\n参数:%@", url,allParam);
    
    [self postRequest:req jsonResponse:^(NSDictionary *result, NSError *error) {
        
        NSError *r_error = nil;
        if (error) {
            r_error = error;
        }
        else {
            AppErrorCode code = (AppErrorCode)[result[@"code"] integerValue];
            if (code != 200) {
                r_error = [NSError serverError:code errorMsg:result[@"message"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(result,r_error);
            }
        });
    }];
}

#pragma mark - private
- (void)postRequest:(NSMutableURLRequest *)req jsonResponse:(void (^)(NSDictionary *result,NSError *error))jsonResponse {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        S_DBG(@"响应url:%@:",[req.URL absoluteString]);
        if (error) {
            if (jsonResponse) {
                jsonResponse(nil,error);
            }
        }
        else if (data == nil) {
            if (jsonResponse) {
                jsonResponse(nil,[ServerApi serverError:CodeResponseIsNil]);
            }
        }
        else {
            NSError *err = nil;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if (err || !jsonObj) {
                S_DBG(@"error:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                if (jsonResponse) {
                    jsonResponse(nil,[ServerApi serverError:CodeResDataFormatError]);
                }
            }
            else {
                NSDictionary *result = jsonObj;
                S_DBG(@"%@",result);
                if (jsonResponse) {
                    jsonResponse(result,nil);
                }
            }
        }
    }];
    [task resume];
}

+ (NSError *)serverError:(AppErrorCode)code {
    
    return [NSError serverError:code errorMsg:[ServerApi codeMessage:code]];
}

+ (NSString *)codeMessage:(AppErrorCode)code {
    
    NSString *msg = @"";
    switch (code) {
        case CodeParamIsNil:
            msg = @"请求参数为空!";
            break;
        case CodeResponseIsNil:
            msg = @"响应数据为空!";
            break;
        case CodeResDataFormatError:
            msg = @"响应数据格式错误!";
            break;
        case CodeIllegalVisit:
            msg = @"非法访问";
            break;
        case CodeUserNotExsit:
            msg = @"用户不存在或被禁止登录";
            break;
        case CodePasswordError:
            msg = @"密码错误";
            break;
        case CodeServerException:
            msg = @"服务器异常";
            break;
        case CodeUserIllegal:
            msg = @"当前登录用户不合法!";
            break;
        case CodeCommandExpired:
            msg = @"登录口令已过期，需重新登录!";
            break;
        default:
            break;
    }
    return msg;
}

@end
