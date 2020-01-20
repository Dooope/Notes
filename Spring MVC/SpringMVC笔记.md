#### 1、isELIgnored属性

 在page directive中的isELIgnored属性用来指定是否忽略。格式为： ＜%@ page isELIgnored＝"true|false"%＞ 如果设定为真，那么JSP中的表达式被当成字符串处理。比如下面这个表达式${2000 % 20}, 在isELIgnored＝"true"时输出为${2000 % 20}，而isELIgnored＝"false"时输出为100。Web容器默认isELIgnored＝"false"。

#### 2、URI和URL的区别比较与理解

一、URI

<1>什么是URI

URI，通一资源标志符(Uniform Resource Identifier， URI)，表示的是web上每一种可用的资源，如 HTML文档、图像、视频片段、程序等都由一个URI进行定位的。

<2>URI的结构组成

URI通常由三部分组成：

①访问资源的命名机制；

②存放资源的主机名；

③资源自身的名称。

<3>URI举例

如：https://blog.csdn.net/qq_32595453/article/details/79516787

我们可以这样解释它：

①这是一个可以通过https协议访问的资源，

②位于主机 blog.csdn.net上，

③通过“/qq_32595453/article/details/79516787”可以对该资源进行唯一标识（注意，这个不一定是完整的路径）

注意：以上三点只不过是对实例的解释，以上三点并不是URI的必要条件，URI只是一种概念，怎样实现无所谓，只要它唯一标识一个资源就可以了。

二、URL

URL是URI的一个子集。它是Uniform Resource Locator的缩写，译为“统一资源定位 符”。

通俗地说，URL是Internet上描述信息资源的字符串，主要用在各种WWW客户程序和服务器程序上。

采用URL可以用一种统一的格式来描述各种信息资源，包括文件、服务器的地址和目录等。URL是URI概念的一种实现方式。

URL的一般格式为(带方括号[]的为可选项)：

protocol :// hostname[:port] / path / [;parameters][?query]#fragment

URL的格式由三部分组成： 

①第一部分是协议(或称为服务方式)。

②第二部分是存有该资源的主机IP地址(有时也包括端口号)。

③第三部分是主机资源的具体地址，如目录和文件名等。

第一部分和第二部分用“://”符号隔开，

第二部分和第三部分用“/”符号隔开。

第一部分和第二部分是不可缺少的，第三部分有时可以省略。 

三、URI和URL之间的区别

从上面的例子来看，你可能觉得URI和URL可能是相同的概念，其实并不是，URI和URL都定义了资源是什么，但URL还定义了该如何访问资源。URL是一种具体的URI，它是URI的一个子集，它不仅唯一标识资源，而且还提供了定位该资源的信息。URI 是一种语义上的抽象概念，可以是绝对的，也可以是相对的，而URL则必须提供足够的信息来定位，是绝对的。

#### 3、重定向和转发的区别及应用

##### 重定向

重定向过程：客户浏览器发送http请求,web服务器接受后发送302状态码响应及对应新的location给客户浏览器,客户浏览器发现是302响应，则自动再发送一个新的http请求，请求url是新的location地址,服务器根据此请求寻找资源并发送给客户。在这里location可以重定向到任意URL，既然是浏览器重新发出了请求，则就没有什么request传递的概念了。在客户浏览器路径栏显示的是其重定向的路径，客户可以观察到地址的变化的。重定向行为是浏览器做了至少两次的访问请求的。

重定向到某一个页面。
response.sendRedirect(“xx.jsp”);
最先开始程序员们使用的重定向方法：response.setStatus(302);response.addHeader(“Location”,”URL”);

sendRedirect()这个方法属于response的方法，当这个请求处理完之后，看到response.senRedirect()，将立即返回客户端，然后客户端再重新发送一个请求，去访问xx.jsp页面。

重定向流程为：客户端请求—-响应，遇到sendRedirect()，返回响应—-客户端再次请求xx.jsp页面—-响应。
这里两个请求互不干扰，相互独立，在前面request里面setAttribute()的任何东西，在后面的request里面都获得不了。

总结一下：在response.sendRedirect(“xx.jsp”);里面是两个请求，两个响应，地址栏会发生改变。

##### 转发

转发过程：客户浏览器发送http请求,web服务器接受此请求,调用内部的一个方法在容器内部完成请求处理和转发动作,将目标资源发送给客户;在这里，转发的路径必须是同一个web容器下的url，其不能转向到其他的web路径上去，中间传递的是自己的容器内的request。在客户浏览器路径栏显示的仍然是其第一次访问的路径，也就是说客户是感觉不到服务器做了转发的。转发行为是浏览器只做了一次访问请求。

通过转发将请求提交给别的地方进行处理
request.getRequestDispatcher(“new.jsp”).forward(request,response);
当发送请求时，服务器会根据请求创建一个代表请求的request对象和一个代表响应的response对象。
当response返回数据时，并不是直接提交到页面上，而是先存储在了response自己的缓存区，当整个请求结束的时候，服务器会将response缓存区中的内容全部取出，返回给页面。

当多次forward时会报以下错误：

java.lang.IllegalStateException: Illegal access: this web application instance has been stopped already. Could not load [com.mysql.jdbc.ProfilerEventHandlerFactory]. The following stack trace is thrown for debugging purposes as well as to attempt to terminate the thread which caused the illegal access.
主要意思是这个应用程序已经被停止了，没有办法加载[com.mysql.jdbc.ProfilerEventHandlerFactory]，并终止导致非法访问的线程。

forward能不能被执行取决于response有没有被提交，如果response被提交了，就会抛出异常，如果response没有被提交，forward会被执行，而response缓存区中的内容将被清空，之前传过来的数据也将丢失，如果需要再次传输数据，可以通过request.setAttribute(“xxx”, 传递的信息);将信息放到request中，而转发的对象可以通过request.getAttribute(“xxx”)获取传过来的信息

总结一下：一次请求只会有一次响应，当响应结束提交，没有办法再次向页面提交数据。整个流程都是在服务器端完成的，而且是在同一个请求里面完成的，整个转发一个请求，一个响应，地址栏不会发生变化。

重定向的跨域访问：
重定向可以跨域访问，而转发是在web服务器内部进行的，不能跨域访问。
同源策略：指的是浏览器对不同源的脚本或者文本的访问方式进行的限制。两个页面具有相同的协议，主机（也常说域名），端口，三个要素缺一不可。
页面中的链接，重定向以及表单提交是不会受到同源策略限制的。