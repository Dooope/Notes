#### MySQL版本的相关问题：com.mysql.cj.jdbc.Driver和com.mysql.jdbc.Driver    

1. 在使用mysql时，控制台日志报错如下：
Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
报错原因：
    MySQL5用的驱动url是com.mysql.jdbc.Driver，MySQL6以后用的是com.mysql.cj.jdbc.Driver。版本不匹配便会报驱动类已过时的错误。
解决方法：
    更改配置文件中的驱动类名字就可以消除驱动类过时的警告了。


2. JDBC连接MySQL6 （com.mysql.cj.jdbc.Driver）， 需要指定时区serverTimezone，否则会报如下错误：
复制代码
org.mybatis.spring.MyBatisSystemException:
            nested exception is org.apache.ibatis.exceptions.PersistenceException:
                ### Error querying database.
            Cause: org.springframework.jdbc.CannotGetJdbcConnectionException:
                Could not get JDBC Connection; nested exception is org.apache.commons.dbcp.SQLNestedException:
            Cannot create PoolableConnectionFactory (The server time zone value '�й���׼ʱ��' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.)
复制代码

3.还有一个警告：
复制代码
WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
/**
不推荐不使用服务器身份验证来建立SSL连接。 
如果未明确设置，MySQL 5.5.45+, 5.6.26+ and 5.7.6+版本默认要求建立SSL连接。 
为了符合当前不使用SSL连接的应用程序，verifyServerCertificate属性设置为’false’。 
如果你不需要使用SSL连接，你需要通过设置useSSL=false来显式禁用SSL连接。 
如果你需要用SSL连接，就要为服务器证书验证提供信任库，并设置useSSL=true。
**/
复制代码
           　　
名词解释：
    SSL – Secure Sockets Layer（安全套接层）
    所以，使用mysql6的连接字符串建议使用如下：
jdbc.url=jdbc:mysql://localhost:3306/your_database?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false
//更详细的连接字符创参考：

mysql.url=jdbc:mysql://127.0.0.1:3306/dbname?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&characterSetResults=utf8&useSSL=false&verifyServerCertificate=false&autoReconnct=true&autoReconnectForPools=true&allowMultiQueries=true
         以上配置的写法是写在单独的配置文件properties中,使用xml文件配置的写法略有不同，需要将每一个配置用分号; 隔开，需要注意的是分号;在xml中需要转义。XML文件中的写法：

<property name="url" value="jdbc:mysql://localhost/lujx?serverTimezone=UTC&amp;useSSL=false" />



#### 模板引擎技术？

​		模板引擎（这里特指用于Web开发的模板引擎）是为了使用户界面与业务数据（内容）分离而产生的，它可以生成特定格式的文档，用于网站的模板引擎就会生成一个标准的[HTML](https://baike.baidu.com/item/HTML/97049)文档。

常用的有freemarker、velocity、jsp、Thymeleaf等

#### 上下文？Web Context？

工程的环境，配置信息

#### SPI？ 

SPI ，全称为 Service Provider Interface，是一种服务发现机制。它通过在ClassPath路径下的META-INF/services文件夹查找文件，自动加载文件里所定义的类。（自动注册）



使⽤原⽣sql语句查询，需要将nativeQuery属性设置为true，默认为false（jpql）或者设置实体类上的属性@Entity(name = "表名")



**spring-autoconfigure-metadata.properties / spring.factories ？**

**spring-autoconfigure-metadata.properties** 中编写类自动配置的条件；

**spring.factories**中编写需要自动配置的类。

 我们知道在Spring及SpringBoot里按条件创建Bean的核心是`Condition`接口与`Conditional`注解,其实在SpringBoot里还有一种AutoConfigure也可以来过滤配置，只不过使用这种技术，能够让SpringBoot更快速的启动。

SpringBoot使用一个Annotation的处理器来收集一些自动装配的条件，那么这些条件可以在`META-INF/spring-autoconfigure-metadata.properties`进行配置。SpringBoot会将收集好的`@Configuration`进行一次过滤进而剔除不满足条件的配置类。

 根据官网说法，使用这种配置方式可以有效的降低SpringBoot的启动时间，因为通过这种过滤方式能减少`@Configuration`类的数量，从而降低初始化Bean时的耗时。