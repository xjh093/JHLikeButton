# JHLikeButton
点赞动画

---

# What

![image](https://github.com/xjh093/JHLikeButton/blob/master/gif.gif)

# Example

```
    JHLikeButton *likeButton = [[JHLikeButton alloc] init];
    likeButton.frame = CGRectMake(150, 200, 40, 40);
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
