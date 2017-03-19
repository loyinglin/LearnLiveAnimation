//
//  LYGLKViewController.m
//  LearnAnimation
//
//  Created by 木头 on 16/5/4.
//  Copyright © 2016年 木头. All rights reserved.
//

#import "LYGLKViewController.h"

@interface LYGLKViewController()

@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;

@property (nonatomic , assign) int mFrameLeftCount;
@property (nonatomic , assign) int mFrameInterval;
@property (nonatomic , assign) int mFrameCurrent;

@end

@implementation LYGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24; // 模板缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
    
    
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"gift_fireworks_1" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
    self.mEffect.texture2d0.target = textureInfo.target;
    self.mFrameInterval = 2;
    self.mFrameCurrent = 0;
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mContext = nil;
    [EAGLContext setCurrentContext:nil];
}

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  场景数据变化
 */
- (void)update {
    
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    if (self.mFrameLeftCount) {
        --self.mFrameLeftCount;
        return ;
    }
    ++self.mFrameCurrent;
    self.mFrameLeftCount = self.mFrameInterval;
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    GLfloat positions[] = {
    0.5, -0.5, 0.0f,
    -0.5, 0.5, 0.0f,
    -0.5, -0.5, 0.0f,
    0.5, 0.5, 0.0f,
    };
    
    GLfloat textureCoords[] = {
        1.0f, 0.0f, //右下
        0.0f, 1.0f, //左上
        0.0f, 0.0f, //左下
        1.0f, 1.0f, //右上
    };
    
    textureCoords[0] = 0.1 * (self.mFrameCurrent % 10 + 1);
    textureCoords[2] = 0.1 * (self.mFrameCurrent % 10);
    textureCoords[4] = 0.1 * (self.mFrameCurrent % 10);
    textureCoords[6] = 0.1 * (self.mFrameCurrent % 10 + 1);
    

    
    //顶点索引
    GLuint indices[] =
    {
        0, 1, 2,
        1, 3, 0
    };
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, positions);
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureCoords);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, sizeof(indices) / sizeof(indices[0]), GL_UNSIGNED_INT, indices);
}

@end
