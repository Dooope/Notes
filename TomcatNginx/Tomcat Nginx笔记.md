#### **1、实现多线程的方式？**

（1）、继承Thread类，实现run()方法

​		public class MyThread extends Thread {    @Override    public void run() {            }}

​		MyThread myThread = new MyThread(socket,servletMap);

​		myThread.start();

（2）、实现Runnable接口类，实现run()方法，使用Thread.start()调用

​		public class MyRunnable  implements Runnable{        @Override    public void run() {            }}

​		MyRunnable myRunnable = new MyRunnable();Thread thread = new 	         

​		Thread(myRunnable);thread.start();

#### **2、线程start( ) 后，会自动关闭吗？**

​	start()就是使该线程开始运行，JVM会调用线程的run()方法；

​	让线程的run()方法执行完，线程自然结束。

#### **3、阻塞式**

​	Java阻塞IO API包含在Java.net包下的JDK中，通常最简单易用。

​	此API基于可以读取或写入的字节流和字符流。 没有可用于前后移动的索引，就像在数组中一样，它只是一个连续的数据流。

​	每次客户端请求连接到服务器时，它都会阻塞一个线程。 因此，如果我们希望有许多同时连接，我们必须创建足够大的线程池。

```java
		ServerSocket serverSocket = new ServerSocket (port) ;
        while (true) {
            Socket client = serverSocket.accept();
            try {
                InputStream inputStream = client.getInputStream();
                // 获取输入流中的请求信息
                int count = 0;
                // 由于网络间断性，请求到达时，数据可能还没到达，此时available()可能为空
                while (count == 0){
                    count = inputStream.available();
                }

                BufferedReader in = new BufferedReader (
                        new InputStreamReader(inputStream)
                );
                OutputStream out = client.getOutputStream();
                in.lines ().forEach(line -> {
                    try {
                        out.write(line.getBytes());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                });
                client. close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
```

1）、使用给定端口创建ServerSocket以进行侦听。

2）、当调用accept（）并开始监听客户端连接时，服务器将阻塞。

3）、 如果客户端请求连接，则accept（）返回一个Socket。

4）、 现在，我们可以从客户端（InputStream）读取并将数据发送回客户端（OutputStream）。

如果我们想允许多个连接，我们必须创建一个线程池：


```java
    // 定义一个线程池
    int corePoolSize = 10;
    int maximumPoolSize =50;
    long keepAliveTime = 100L;
    TimeUnit unit = TimeUnit.SECONDS;
    BlockingQueue<Runnable> workQueue = new ArrayBlockingQueue<>(50);
    ThreadFactory threadFactory = Executors.defaultThreadFactory();
    RejectedExecutionHandler handler = new ThreadPoolExecutor.AbortPolicy();    
    ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(
        corePoolSize,
        maximumPoolSize,
        keepAliveTime,
        unit,
        workQueue,
        threadFactory,
        handler
    );
    threadPoolExecutor.execute(thread);
```
#### **4、Java中获取路径？**

1. java获取路径
利用System.getProperty()函数获取当前路径：
System.out.println(System.getProperty("user.dir"));//user.dir指定了当前的路径 
使用File提供的函数获取当前路径：
File directory = new File("");//设定为当前文件夹 
try{ 
//获取标准的路径 ,D:\develop_tool\Tomcat\apache-tomcat-8.5.16\bin
   System.out.println(directory.getCanonicalPath());
   //获取绝对路径 ,D:\develop_tool\Tomcat\apache-tomcat-8.5.16\bin
   System.out.println(directory.getAbsolutePath());
   }catch(Exceptin e){} 

2. jsp中取得路径：
    以工程名为TEST为例：

  得到包含工程名的当前页面全路径：request.getRequestURI()
  结果：/TEST/test.jsp
  得到工程名：request.getContextPath()
  结果：/TEST
  得到当前页面所在目录下全名称：request.getServletPath()
  结果：如果页面在jsp目录下 /TEST/jsp/test.jsp
  得到页面所在服务器的全路径：application.getRealPath("页面.jsp")
  结果：D:/resin/webapps/TEST/test.jsp
  得到页面所在服务器的绝对路径：absPath=new java.io.File(application.getRealPath(request.getRequestURI())).getParent();
  结果：D:/resin/webapps/TEST

3. 在类中取得路径：
    类的绝对路径：Class.class.getClass().getResource("/").getPath()
    结果：/D:/TEST/WebRoot/WEB-INF/classes/pack/
    得到工程的路径：System.getProperty("user.dir")
    结果：D:/TEST

4. 在Servlet中取得路径：
    (1)得到工程目录：request.getSession().getServletContext().getRealPath("")参数可具体到包名。
    结果：E:/Tomcat/webapps/TEST
    (2)得到IE地址栏地址：request.getRequestURL()
    结果：http://localhost:8080/TEST/test
    (3)得到相对地址：request.getRequestURI()
    结果：/TEST/test

#### **5、abstract**

用关键字abstract修饰的类称为abstract类（抽象类），比如：

abstract classA{

}

用关键字abstract修饰的方法称为abstract方法（抽象方法），例如：

abstract int min （int x，int y）；

  对于abstract方法只允许声明，不允许实现（因为没有方法体）（毕竟叫抽象，当然不能实实在在的让你实现），并且不允许使用final和abstract同时修饰一个方法或者类，也不允许使用static修饰abstract方法。也就是说，abstract方法只能是实例方法，不能是类方法。

1.abstract类中可以有abstract方法

 abstract类中可以有abstract方法，也可以有非abstract方法

 非abstract类中不可以有abstract方法

2.abstract类不能使用new运算符创建对象

但是如果一个非抽象类是抽象类的子类，这时候我们想要创建该对象呢，这时候它就必须要重写父类的抽象方法，并且给出方法体，这也就是说明了为什么不允许使用final和abstract同时修饰一个类或者方法的原因。

重点常考！：final和abstract，private和abstract，static和abstract，这些是不能放在一起的修饰符，因为abstract修饰的方法是必须在其子类中实现（覆盖），才能以多态方式调用，以上修饰符在修饰方法时期子类都覆盖不了这个方法，final是不可以覆盖，private是不能够继承到子类，所以也就不能覆盖，static是可以覆盖的，但是在调用时会调用编译时类型的方法，因为调用的是父类的方法，而父类的方法又是抽象的方法，又不能够调用，所以上的修饰符不能放在一起。

3.abstract类的子类

如果一个非abstract类是abstract类的子类，它必须重写父类的abstract方法，也就是去掉abstract方法的abstract修饰，并给出方法体。

如果一个abstract类是abstract类的子类，它可以重写父类的abstract方法，也可以继承父类的abstract方法。

#### **6、XPath**

​	XPath 是一门在 XML 文档中查找信息的语言。

#### **7、正向代理和反向代理的区别**

1. 概念
  		正向代理是一个位于客户端和目标服务器之间的代理服务器(中间服务器)。为了从原始服务器取得内容，客户端向代理服务器发送一个请求，并且指定目标服务器，之后代理向目标服务器转交并且将获得的内容返回给客户端。正向代理的情况下客户端必须要进行一些特别的设置才能使用。

    反向代理正好相反。对于客户端来说，反向代理就好像目标服务器。并且客户端不需要进行任何设置。客户端向反向代理发送请求，接着反向代理判断请求走向何处，并将请求转交给客户端，使得这些内容就好似他自己一样，一次客户端并不会感知到反向代理后面的服务，也因此不需要客户端做任何设置，只需要把反向代理服务器当成真正的服务器就好了。
  
2. 区别
             正向代理需要你主动设置代理服务器ip或者域名进行访问，由设置的服务器ip或者域名去获取访问内容并返回；而反向代理不需要你做任何设置，直接访问服务器真实ip或者域名，但是服务器内部会自动根据访问内容进行跳转及内容返回，你不知道它最终访问的是哪些机器。

            正向代理是代理客户端，为客户端收发请求，使真实客户端对服务器不可见；而反向代理是代理服务器端，为服务器收发请求，使真实服务器对客户端不可见。

  从上面的描述也能看得出来正向代理和反向代理最关键的两点区别：

​		**是否指定目标服务器**

​		**客户端是否要做设置**

#### **8、nginx 中 gzip使用**

​	客户端http请求头声明浏览器支持的压缩方式，服务端配置启用压缩，压缩的文件类型，压缩方式。当客户端请求到服务端的时候，服务器解析请求头，如果客户端支持gzip压缩，响应时对请求的资源进行压缩并返回给客户端，浏览器按照自己的方式解析。

​	配置服务端使用gzip

​	浏览器要支持gzip （现代浏览器都支持，比如：chrome、Firefox、Safari...）

​	配置前端使用gzip

​	gzip使用环境:http,server,location,if(x),一般把它定义在nginx.conf的http{…..}之间

- **gzip on**
  on为启用，off为关闭
- **gzip_min_length 1k**
  设置允许压缩的页面最小字节数，页面字节数从header头中的Content-Length中进行获取。默认值是0，不管页面多大都压缩。建议设置成大于1k的字节数，小于1k可能会越压越大。
- **gzip_buffers 4 16k**
  获取多少内存用于缓存压缩结果，‘4 16k’表示以16k*4为单位获得
- **gzip_comp_level 5**
  gzip压缩比（1~9），越小压缩效果越差，但是越大处理越慢，所以一般取中间值;
- **gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php**
  对特定的MIME类型生效,其中'text/html’被系统强制启用
- **gzip_http_version 1.1**
  识别http协议的版本,早起浏览器可能不支持gzip自解压,用户会看到乱码
- **gzip_vary on**
  启用应答头"Vary: Accept-Encoding"
- **gzip_proxied off**
  nginx做为反向代理时启用,off(关闭所有代理结果的数据的压缩),expired(启用压缩,如果header头中包括"Expires"头信息),no-cache(启用压缩,header头中包含"Cache-Control:no-cache"),no-store(启用压缩,header头中包含"Cache-Control:no-store"),private(启用压缩,header头中包含"Cache-Control:private"),no_last_modefied(启用压缩,header头中不包含"Last-Modified"),no_etag(启用压缩,如果header头中不包含"Etag"头信息),auth(启用压缩,如果header头中包含"Authorization"头信息)
- **gzip_disable msie6**
  (IE5.5和IE6 SP1使用msie6参数来禁止gzip压缩 )指定哪些不需要gzip压缩的浏览器(将和User-Agents进行匹配),依赖于PCRE库

#### 9、Nginx状态码

先来再回顾一下一个http请求处理流程：

![img](https://images2018.cnblogs.com/blog/1305952/201805/1305952-20180522151417168-694813782.jpg)

一个普通的http请求处理流程，如上图所示： A -> client端发起请求给nginx B -> nginx处理后，将请求转发到uwsgi，并等待结果 C -> uwsgi处理完请求后，返回数据给nginx D -> nginx将处理结果返回给客户端 每个阶段都会有一个预设的超时时间，由于网络、机器负载、代码异常等等各种原因，如果某个阶段没有在预期的时间内正常返回，就会导致这次请求异常，进而产生不同的状态码。

1）504

504主要是针对B、C阶段。一般nginx配置中会有：

```
location / {``  ``...``  ``uwsgi_connect_timeout 6s;``  ``uwsgi_send_timeout 6s;``  ``uwsgi_read_timeout 10s;``  ``uwsgi_buffering on;``  ``uwsgi_buffers 80 16k;``  ``...``}
```

这个代表nginx与上游服务器（uwsgi）通信的超时时间，也就是说，如果在这个时间内，uwsgi没有响应，则认为这次请求超时，返回504状态码。

具体的日志如下：

```
access_log[16``/May/2016``:22:11:38 +0800] 10.4.31.56 201605162211280100040310561523 15231401463407888908 10.*.*.* 127.0.0.1:8500 ``"GET /api/media_article_list/?count=10&source_type=0&status=all&from_time=0&item_id=0&flag=2&_=1463407896337 HTTP/1.1"` `504 **.***.com **.**.**.39, **.**.**.60 10.000 10.000 ``"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36"` `...error_log2016``/05/16` `22:11:38 [error] 90674``#0: *947302032 upstream timed out (110: Connection timed out) while reading response header from upstream, client: 10.6.19.81, server: **.***.com, request: "GET /api/media_article_list/?count=10&source_type=0&status=all&from_time=0&item_id=0&flag=2&_=1463407896337 HTTP/1.1", upstream: "http://127.0.0.1:8500/**/**/api/media_article_list/?count=10&source_type=0&status=all&from_time=0&item_id=0&flag=2&_=1463407896337", host: "mp.toutiao.com", referrer: "https://**.***.com/articles/?source_type=0"error_log中upstream timed out (110: Connection timed out) while reading response header from upstream，``意思是说，在规定的时间内，没有从header中拿到数据，即uwsgi没有返回任何数据。
```

2）502

502主要针对B 、C阶段。产生502的时候，对应的error_log中的内容会有好几种：

access_log

```
[16``/May/2016``:16:39:49 +0800] 10.4.31.56 201605161639490100040310562612 2612221463387989972 10.6.19.81 127.0.0.1:88 ``"GET /articles/?source_type=0 HTTP/1.1"` `503 **.***.com **.**.**.4, **.**.**.160 0.000 0.000 ``"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36"` `"uuid=\x22w:546d345b86ca443eb44bd9bb1120e821\x22; tt_webid=15660522398; lasttag=news_culture; sessionid=f172028cc8310ba7f503adb5957eb3ea; sid_tt=f172028cc8310ba7f503adb5957eb3ea; _ga=GA1.2.354066248.1463056713; _gat=1"
```

error_log

```
2016``/05/16` `16:39:49 [error] 90693``#0: *944980723 recv() failed (104: Connection reset by peer) while reading response header from upstream, client: 10.6.19.80, server: **.***.com, request: "GET /articles/ HTTP/1.1", upstream: "http://127.0.0.1:8500/**/**/articles/", host: "**.***.com", referrer: "http://**.***.com/new_article/"
```

列一下常见的几种502对应的 error_log：

- recv() failed (104: Connection reset by peer) while reading response header from upstream
- upstream prematurely closed connection while reading response header from upstream
- connect() failed (111: Connection refused) while connecting to upstream
- ....

这些都代表，在nginx设置的超时时间内，上游uwsgi没有给正确的响应（但是是有响应的，不然如果一直没响应，就会变成504超时了），因此nginx这边的状态码为502。

如上，access_log中出现503，为什么？

这个是因为nginx upstream的容灾机制。如果nginx有如下配置：

```
upstream app_backup {``  ``server 127.0.0.1:8500 max_fails=3 fail_timeout=5s;``  ``server 127.0.0.1:88 backup;``}
```

- max_fails=3 说明尝试3次后，会认为“ server 127.0.0.1:8500” 失效，于是进入 “server 127.0.0.1:88 backup”，即访问本机的88端口;

nginx upstream的容灾机制，默认情况下，Nginx 默认判断失败节点状态以connect refuse和time out状态为准，不过location里加了这个配置：

```
proxy_next_upstream error http_502;``proxy_connect_timeout 1s; ``proxy_send_timeout  6s; ``proxy_read_timeout  10s;``proxy_set_header Host $host;
```

- 这个配置是说，对于http状态是502的情况，也会走upstream的容灾机制；
- 概括一下就是，如果连续有3次(max_fails=3)状态为502的请求，则会任务这个后端server 127.0.0.1:8500 挂掉了，在接下来的5s(fail_timeout=5s)内，就会访问backup，即server 127.0.0.1:88 ，看下88端口对应的是什么：

```
server {                                                                        `` ``listen 88;  `` ``access_log ``/var/log/nginx/failover``.log;  `` ``expires 1m;  `` ``error_page 500 502 503 504 ``/500``.html;  `` ``location / {    ``   ``return` `503;   `` ``}  `` ``location = ``/500``.html {    ``   ``root /**/**/**``/nginx/5xx/``;  `` ``}``}
```

这个的意思就是，对于访问88端口的请求，nginx会返回503状态码，同时返回/opt/tiger/ss_conf/nginx/5xx/这个路径下的500.html文件。 因此，access_log中看到的是503

3）499

client发送请求后，如果在规定的时间内（假设超时时间为500ms）没有拿到nginx给的响应，则认为这次请求超时，会主动结束，这个时候nginx的access_log就会打印499状态码。 A+B+C+D > 500ms 其实这个时候，server端有可能还在处理请求，只不过client断掉了连接，因此处理结果也无法返回给客户端。 499如果比较多的话，可能会引起服务雪崩。 比如说，client一直在发起请求，客户端因为某些原因处理慢了，没有在规定时间内返回数据，client认为请求失败，中断这次请求，然后再重新发起请求。这样不断的重复，服务端的请求越来越多，机器负载变大，请求处理越来越慢，没有办法响应任何请求

官网总结nginx返回499的情况，是由于：

```
client has closed connection  ``#客户端主动关闭了连接。
```

解决的话，可以添加

```
proxy_ignore_client_abort  on;
```

还有一种原因，确实是客户端关闭了连接，或者连接超时。主要是因为PHP进程数太少，或php进程占用，资源不能很快释放，请求堆积。这种情况要解决的话，需要在程序上做优化。

4）500 

服务器内部错误，也就是服务器遇到意外情况，而无法执行请求。发生错误，一般的几种情况：

- web脚本错误，如php语法错误，lua语法错误等。
- 访问量大的时候，由于系统资源限制，而不能打开过多的文件句柄

分析错误的原因

- 查看nginx，php的错误日志
-  如果是too many open files，修改nginx的worker_rlimit_nofile参数，使用ulimit查看系统打开文件限制，修改/etc/security/limits.conf
- 如果脚本存在问题，则需要修复脚本错误，并优化代码
- 各种优化都做好，还是出现too many open files，那就需要考虑做负载均衡，把流量分散到不同服务器上去

5）503

503是服务不可用的返回状态。 由于在nginx配置中，设置了limit_req的流量限制，导致许多请求返回503错误代码，在限流的条件下，为提高用户体验，希望返回正常Code 200，且返回操作频繁的信息：

................................................Nginx Code Status...............................

```xml
200：服务器成功返回网页``403：服务器拒绝请求。404：请求的网页不存在``499：客户端主动断开了连接。500：服务器遇到错误，无法完成请求。502：服务器作为网关或代理，从上游服务器收到无效响应。503 - 服务不可用``504：服务器作为网关或代理，但是没有及时从上游服务器收到请求。``这些状态码被分为五大类：``100-199 用于指定客户端应相应的某些动作。``200-299 用于表示请求成功。``300-399 用于已经移动的文件并且常被包含在定位头信息中指定新的地址信息。``400-499 用于指出客户端的错误。 （自己电脑这边的问题） 自己电脑这边的问题）``500-599 用于支持服务器错误。 （对方的问题） 对方的问题）---------------------------------------------------------------------------------------------200 （成功） 服务器已成功处理了请求。 通常，这表示服务器提供了请求的网页。``201 （已创建） 请求成功并且服务器创建了新的资源。``202 （已接受） 服务器已接受请求，但尚未处理。``203 （非授权信息） 服务器已成功处理了请求，但返回的信息可能来自另一来源。``204 （无内容） 服务器成功处理了请求，但没有返回任何内容。``205 （重置内容） 服务器成功处理了请求，但没有返回任何内容。206 （部分内容） 服务器成功处理了部分 GET 请求。``---------------------------------------------------------------------------------------------300 （多种选择） 针对请求，服务器可执行多种操作。 服务器可根据请求者 (user agent) 选择一项操作，或提供操作列表供请求者选择。``301 （永久移动） 请求的网页已永久移动到新位置。 服务器返回此响应（对 GET 或 HEAD 请求的响应）时，会自动将请求者转到新位置。302 （临时移动） 服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。303 （查看其他位置） 请求者应当对不同的位置使用单独的 GET 请求来检索响应时，服务器返回此代码。304 （未修改） 自从上次请求后，请求的网页未修改过。 服务器返回此响应时，不会返回网页内容。``305 （使用代理） 请求者只能使用代理访问请求的网页。 如果服务器返回此响应，还表示请求者应使用代理。``307 （临时重定向） 服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来进行以后的请求。``---------------------------------------------------------------------------------------------400 （错误请求） 服务器不理解请求的语法。``401 （未授权） 请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。``403 （禁止） 服务器拒绝请求。404 （未找到） 服务器找不到请求的网页。405 （方法禁用） 禁用请求中指定的方法。``406 （不接受） 无法使用请求的内容特性响应请求的网页。``407 （需要代理授权） 此状态代码与 401（未授权）类似，但指定请求者应当授权使用代理。408 （请求超时） 服务器等候请求时发生超时。``409 （冲突） 服务器在完成请求时发生冲突。 服务器必须在响应中包含有关冲突的信息。``410 （已删除） 如果请求的资源已永久删除，服务器就会返回此响应。``411 （需要有效长度） 服务器不接受不含有效内容长度标头字段的请求。``412 （未满足前提条件） 服务器未满足请求者在请求中设置的其中一个前提条件。``413 （请求实体过大） 服务器无法处理请求，因为请求实体过大，超出服务器的处理能力。``414 （请求的 URI 过长） 请求的 URI（通常为网址）过长，服务器无法处理。``415 （不支持的媒体类型） 请求的格式不受请求页面的支持。``416 （请求范围不符合要求） 如果页面无法提供请求的范围，则服务器会返回此状态代码。``417 （未满足期望值） 服务器未满足``"期望"``请求标头字段的要求。``---------------------------------------------------------------------------------------------500 （服务器内部错误） 服务器遇到错误，无法完成请求。``501 （尚未实施） 服务器不具备完成请求的功能。 例如，服务器无法识别请求方法时可能会返回此代码。``502 （错误网关） 服务器作为网关或代理，从上游服务器收到无效响应。``503 （服务不可用） 服务器目前无法使用（由于超载或停机维护）。 通常，这只是暂时状态。``504 （网关超时） 服务器作为网关或代理，但是没有及时从上游服务器收到请求。``505 （HTTP 版本不受支持） 服务器不支持请求中所用的 HTTP 协议版本。
```

proxy_intercept_errors 当上游服务器响应头回来后，可以根据响应状态码的值进行拦截错误处理，与error_page 指令相互结合。用在访问上游服务器出现错误的情况下。

如下的一个配置实例：

```xml
[root@dev ~]``# cat ssl-zp.wangshibo.conf``upstream mianshi1 {``  ``server 192.168.1.33:8080 max_fails=3 fail_timeout=10s;``  ``#server 192.168.1.32:8080 max_fails=3 fail_timeout=10s;``}`` ``server {``  ``listen 443;``  ``server_name zp.wangshibo.com;ssl on;``  ``### SSL log files ###``  ``access_log logs``/zrx_access``.log;``  ``error_log logs``/zrx_error``.log;``  ``### SSL cert files ###``  ``ssl_certificate ssl``/wangshibo``.cer;``  ``ssl_certificate_key ssl``/wangshibo``.key;ssl_session_timeout 5m;``  ``error_page 404 301 https:``//zp``.wangshibo.com``/zrx-web/``;``  ``location ``/zrx-web/` `{``    ``proxy_pass http:``//mianshi1``;``    ``proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;``    ``proxy_set_header Host $host;``    ``proxy_set_header X-Real-IP $remote_addr;proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;``    ``# proxy_set_header X-Forwarded-Proto https;``    ``#proxy_set_header X-Forwarded-Proto https;proxy_redirect off;``    ``proxy_intercept_errors on;``  ``}``}
```

#### 10、为什么要用Nginx？

跨平台、配置简单，非阻塞、高并发连接：处理2-3万并发连接数，官方监测能支持5万并发，

**内存消耗小：**开启10个nginx才占150M内存 ，nginx处理静态文件好,耗费内存少,

**内置的健康检查功能：**如果有一个服务器宕机，会做一个健康检查，再发送的请求就不会发送到宕机的服务器了。重新将请求提交到其他的节点上。

**节省宽带：**支持GZIP压缩，可以添加浏览器本地缓存

**稳定性高：**宕机的概率非常小

**接收用户请求是异步的：**浏览器将请求发送到nginx服务器，它先将用户请求全部接收下来，再一次性发送给后端web服务器，极大减轻了web服务器的压力,一边接收web服务器的返回数据，一边发送给浏览器客户端, 网络依赖性比较低，只要ping通就可以负载均衡,可以有多台nginx服务器 使用dns做负载均衡,事件驱动：通信机制采用epoll模型（nio2 异步非阻塞）

#### **4、请解释Nginx如何处理HTTP请求**

​		首先，nginx在启动时，会解析配置文件，得到需要监听的端口与ip地址，然后在nginx的master进程里面先初始化好这个监控的socket，再进行listen,然后再fork出多个子进程出来,  子进程会竞争accept新的连接。此时，客户端就可以向nginx发起连接了。当客户端与nginx进行三次握手，与nginx建立好一个连接后,此时，某一个子进程会accept成功，然后创建nginx对连接的封装，即ngx_connection_t结构体,接着，根据事件调用相应的事件处理模块，如http模块与客户端进行数据的交换。最后，nginx或客户端来主动关掉连接，到此，一个连接就寿终正寝了。

Nginx 是一个高性能的 Web 服务器，能够同时处理大量的并发请求。它结合多进程机制和异步机制 ，异步机制使用的是异步非阻塞方式 ，接下来就给大家介绍一下 Nginx 的多线程机制和异步非阻塞机制 。

**1、多进程机制**

服务器每当收到一个客户端时，就有 服务器主进程 （ master process ）生成一个 子进程（ worker process ）出来和客户端建立连接进行交互，直到连接断开，该子进程就结束了。

使用进程的好处是各个进程之间相互独立，不需要加锁，减少了使用锁对性能造成影响，同时降低编程的复杂度，降低开发成本。其次，采用独立的进程，可以让进程互相之间不会影响 ，如果一个进程发生异常退出时，其它进程正常工作， master 进程则很快启动新的 worker 进程，确保服务不会中断，从而将风险降到最低。

缺点是操作系统生成一个子进程需要进行 内存复制等操作，在资源和时间上会产生一定的开销。当有大量请求时，会导致系统性能下降 。

**2、异步非阻塞机制**

每个工作进程 使用 异步非阻塞方式 ，可以处理 多个客户端请求 。

当某个 工作进程 接收到客户端的请求以后，调用 IO 进行处理，如果不能立即得到结果，就去 处理其他请求 （即为 非阻塞 ）；而 客户端 在此期间也 无需等待响应 ，可以去处理其他事情（即为 异步 ）。

当 IO 返回时，就会通知此 工作进程 ；该进程得到通知，暂时 挂起 当前处理的事务去 响应客户端请求 。







手写实现迷你版Tomcat中遇到的问题java.io.UncheckedIOException: java.net.SocketException: Software caused connection abort: recv faile，原因？	

为什么Nginx性能这么高？