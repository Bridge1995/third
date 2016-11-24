# dplyr与原生操作对比
## To Mavis H
Happy Thanksgiving
#### 用flights数据集举例
``` r
library(nycflights13)
library(dplyr)
```
## 筛选
### 筛选行
``` 
filter(flights, month == 3, day == 13)
```
#### 等价形式一
```
flights[flights$month == 3 & flights$day == 13, ]
```
在`dataframe`数据结构中用方框和逗号索引行，&表示且，同时筛选多个条件。要多次输入flights，不够简洁，虽可用`attach`，但麻烦，在数据集过多的时候容易乱。
#### 等价形式二
```
subset(flights, month == 3 & day == 13)
```
用subset函数，够简洁，组合条件时，用来表示且的符号不同。
### 筛选列
分别筛选+筛选相邻列+删除列
```
select(flights, year, month, day)
select(flights, day:dep_delay)
select(flights, -(year:day))
```
#### 等价形式
```
subset(flights,col=1:5)
subset(flights,select=c(year:sched_dep_time))
flights[,1:5,]
flights[,-(1:5),]
```

## 排序
```
arrange(flights, year, month, day)
```
#### 等价形式
```
flights[order(flights$year, flights$month, flights$day), ]
```
降序都只需在变量名前加负号，或者des()
排序都很简单，除了加$后原生函数略微繁琐。
## 改名
```
select(flights, tail_num = tailnum)
```
#### 等价形式
```
rename(flights, tail_num = tailnum)
```
没区别
## *去重
```
distinct(select(flights, origin, dest))
```
表示选出flights数据框中，orgin与dest不重复的所有组合。该功能实用强大，至今没找到用原生`unique`函数实现多条件去重复值的方法。可能有，但应该不如`distinct`直白。
## *生成新变量
```
mutate(flights,gain = arr_delay - dep_delay, speed = distance/air_time * 60)
```
#### 等价形式一
```
transform(flights,gain = arr_delay - dep_delay)
gain_per_hour = gain / (air_time / 60)
```
#### 等价形式二
```
transform(flights,
+           gain = arr_delay - dep_delay,
+           gain_per_hour = gain / (air_time / 60)
+ )
```
从上面可以看出，mutate最大的好处是可以引用刚刚生成的变量，而原生的需要写两行。
要么空行，形似`with`或`with`，但我刚刚运行，出现了报错
Error in eval(expr, envir, enclos) : object 'gain' not found，按理是可以，我以前运行成功过。可能因为不能在全局环境中用，数据框也许太多了，有冲突，只是猜测。
## *总结
总的来说，dplyr比原生的R要简洁。简洁体现在两方面：
+ 少打几个字
+ 思路清晰一些，不用考虑数据的维度，会不会少了逗号；也不必考虑全局环境，能否使用刚生成的变量。
**更关键的是dplyr提供管道操作，%>%可以节省中间步骤。想象一下，如果用flights[]直接进行列筛选与排序，已经改动过flights数据框，所以不能这样操作。方法有二：
+ 中间步骤保留，赋值成新的数据框，理清名字
+ 使用空行嵌套结构**
我在举例说明%>%用法中会举个详细的例子，现在，道理我都懂，但还是得再想想。


