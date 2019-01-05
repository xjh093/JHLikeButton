# JHLikeButton
❤️点赞动画，点赞星星，点赞爱心，抖音点赞 ❤️

---

# What

![image](https://github.com/xjh093/JHLikeButton/blob/master/Gif.gif)

---

# Usage

```
    JHLikeButton *likeButton = [[JHLikeButton alloc] init];
    likeButton.frame = CGRectMake(150, 200, 40, 40);
    likeButton.type = JHLikeButtonType_Star;
    [likeButton prepare];
    likeButton.clickBlock = ^(BOOL like) {
        if (like) {
            NSLog(@"yes");
        }else{
            NSLog(@"no");
        }
    };
    [self.view addSubview:likeButton];
```
