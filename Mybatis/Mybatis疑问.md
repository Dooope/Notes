#### 数据库连接与关闭太过频繁，为什么会降低系统性能？系统性能降低了，又会给数据库连接带来什么影响？

1、对数据库的访问会牵涉到磁盘IO的操作，经过一段时间分析发现网站性能差主要是在数据的读写。

2、每次读数据库的更新操作会写日志，减少不必要的磁盘写入。

3、数据库的建立连接是非常耗费资源，有位博友就算过最少是225ms，也就是占用系统服务器这么长时间，而且频繁建立，就是申请内存空间然后释放内存，导致内存碎片无法即使回收；当可用内存少的时候，cpu处理器速度就会变慢，为了等待资源释放；之后所有的程序运行速度变慢！

数据库频繁创建连接、释放资源：使用连接池解决

#### 构建者模式、工厂模式、代理模式

#### mapper的四种加载方式？以及如何应用？

注解开发、接口开发（getMapper）、普通方式

<!-- 使用相对于类路径的资源引用 -->
<mappers>
  <mapper resource="org/mybatis/builder/AuthorMapper.xml"/>
</mappers>
<!-- 使用完全限定资源定位符（URL） -->
<mappers>
  <mapper url="file:///var/mappers/AuthorMapper.xml"/>
</mappers>
<!-- 使用映射器接口实现类的完全限定类名 -->
<mappers>
  <mapper class="org.mybatis.builder.AuthorMapper"/>
</mappers>
<!-- 将包内的映射器接口实现全部注册为映射器 -->
<mappers>
  <package name="org.mybatis.builder"/>
</mappers>

一级缓存失效场景？二级缓存失效场景？

动态sql的原理？

BoundSql?

#### 插件的实现原理？

Mybatis支持用插件在已映射语句执行过程中的某一点进行拦截调用，对于mybatis来说插件就是拦截器，用来增强核心对象的功能，增强的本质上是借助于底层的动态代理实现的，也就是说，Mybatis中的四大对象都是代理对象。

Mybatis在创建四大对象的时候：

1、每个创建出来的对象不是直接返回的，而是interceptorChain.pluginAll(parameterHandler);

2、获取到所有的Interceptor（拦截器）（插件需要实现的接口）；调用interceptor.plugin(target);返回target包装后的对象

3、插件机制，我们可以使用插件为目标对象创建一个代理对象；AOP（面向切面）我们的插件可以为四大对象创建出代理对象；代理对象就可以拦截到四大对象的每一个执行；

基本概念：
1 拦截器的作用就是我们可以拦截某些方法的调用，在目标方法前后加上我们自己逻辑
2 Mybatis拦截器设计的一个初衷是为了供用户在某些时候可以实现自己的逻辑而不必去动Mybatis固有的逻辑。

实现一个自定义拦截器
Mybatis为我们提供了一个Interceptor接口，通过实现该接口就可以定义我们自己的拦截器。请耐心看完代码注释
代码案例1

/**
 * mybatis 自定义拦截器
 * 三步骤：
 *  1 实现 {@link Interceptor} 接口
 *  2 添加拦截注解 {@link Intercepts}
 *  3 配置文件中添加拦截器
 *
 * 1 实现 {@link Interceptor} 接口
 *      具体作用可以看下面代码每个方法的注释
 * 2 添加拦截注解 {@link Intercepts}
 *      mybatis 拦截器默认可拦截的类型只有四种，即四种接口类型 Executor、StatementHandler、ParameterHandler 和 ResultSetHandler
 *      对于我们的自定义拦截器必须使用 mybatis 提供的注解来指明我们要拦截的是四类中的哪一个类接口
 *      具体规则如下：
 *          a：Intercepts 标识我的类是一个拦截器
 *          b：Signature 则是指明我们的拦截器需要拦截哪一个接口的哪一个方法
 *              type    对应四类接口中的某一个，比如是 Executor
 *              method  对应接口中的哪类方法，比如 Executor 的 update 方法
 *              args    对应接口中的哪一个方法，比如 Executor 中 query 因为重载原因，方法有多个，args 就是指明参数类型，从而确定是哪一个方法
 * 3 配置文件中添加拦截器
 *      拦截器其实就是一个 plugin，在 mybatis 核心配置文件中我们需要配置我们的 plugin ：
 *          <plugin interceptor="liu.york.mybatis.study.plugin.MyInterceptor">
 *              <property name="username" value="LiuYork"/>
 *              <property name="password" value="123456"/>
 *          </plugin>
 *
 * 拦截器顺序
 * 1 不同拦截器顺序：
 *      Executor -> ParameterHandler -> StatementHandler -> ResultSetHandler
 *
 * 2 对于同一个类型的拦截器的不同对象拦截顺序：
 *      在 mybatis 核心配置文件根据配置的位置，拦截顺序是 从上往下
 */
@Intercepts({
        @Signature(method = "update", type = Executor.class, args = {MappedStatement.class, Object.class}),
        @Signature(method = "query", type = StatementHandler.class, args = {Statement.class, ResultHandler.class})
})
public class MyInterceptor implements Interceptor {

    /**
     * 这个方法很好理解
     * 作用只有一个：我们不是拦截方法吗，拦截之后我们要做什么事情呢？
     *      这个方法里面就是我们要做的事情
     *
     * 解释这个方法前，我们一定要理解方法参数 {@link Invocation} 是个什么鬼？
     * 1 我们知道，mybatis拦截器默认只能拦截四种类型 Executor、StatementHandler、ParameterHandler 和 ResultSetHandler
     * 2 不管是哪种代理，代理的目标对象就是我们要拦截对象，举例说明：
     *      比如我们要拦截 {@link Executor#update(MappedStatement ms, Object parameter)} 方法，
     *      那么 Invocation 就是这个对象，Invocation 里面有三个参数 target method args
     *          target 就是 Executor
     *          method 就是 update
     *          args   就是 MappedStatement ms, Object parameter
     *
     *   如果还是不能理解，我再举一个需求案例：看下面方法代码里面的需求
     *
     *  该方法在运行时调用
     */
    @Override
    public Object intercept(Invocation invocation) throws Throwable {

        /*
         * 需求：我们需要对所有更新操作前打印查询语句的 sql 日志
         * 那我就可以让我们的自定义拦截器 MyInterceptor 拦截 Executor 的 update 方法，在 update 执行前打印sql日志
         * 比如我们拦截点是 Executor 的 update 方法 ：  int update(MappedStatement ms, Object parameter)
         *
         * 那当我们日志打印成功之后，我们是不是还需要调用这个query方法呢，如何如调用呢？
         * 所以就出现了 Invocation 对象，它这个时候其实就是一个 Executor，而且 method 对应的就是 query 方法，我们
         * 想要调用这个方法，只需要执行 invocation.proceed()
         */

        /* 因为我拦截的就是Executor，所以我可以强转为 Executor，默认情况下，这个Executor 是个 SimpleExecutor */
        Executor executor = (Executor)invocation.getTarget();

        /*
         * Executor 的 update 方法里面有一个参数 MappedStatement，它是包含了 sql 语句的，所以我获取这个对象
         * 以下是伪代码，思路：
         * 1 通过反射从 Executor 对象中获取 MappedStatement 对象
         * 2 从 MappedStatement 对象中获取 SqlSource 对象
         * 3 然后从 SqlSource 对象中获取获取 BoundSql 对象
         * 4 最后通过 BoundSql#getSql 方法获取 sql
         */
        MappedStatement mappedStatement = ReflectUtil.getMethodField(executor, MappedStatement.class);
        SqlSource sqlSource = ReflectUtil.getField(mappedStatement, SqlSource.class);
        BoundSql boundSql = sqlSource.getBoundSql(args);
        String sql = boundSql.getSql();
        logger.info(sql);

        /*
         * 现在日志已经打印，需要调用目标对象的方法完成 update 操作
         * 我们直接调用 invocation.proceed() 方法
         * 进入源码其实就是一个常见的反射调用 method.invoke(target, args)
         * target 对应 Executor对象
         * method 对应 Executor的update方法
         * args   对应 Executor的update方法的参数
         */

        return invocation.proceed();
    }

    /**
     * 这个方法也很好理解
     * 作用就只有一个：那就是Mybatis在创建拦截器代理时候会判断一次，当前这个类 MyInterceptor 到底需不需要生成一个代理进行拦截，
     * 如果需要拦截，就生成一个代理对象，这个代理就是一个 {@link Plugin}，它实现了jdk的动态代理接口 {@link InvocationHandler}，
     * 如果不需要代理，则直接返回目标对象本身
     *
     * Mybatis为什么会判断一次是否需要代理呢？
     * 默认情况下，Mybatis只能拦截四种类型的接口：Executor、StatementHandler、ParameterHandler 和 ResultSetHandler
     * 通过 {@link Intercepts} 和 {@link Signature} 两个注解共同完成
     * 试想一下，如果我们开发人员在自定义拦截器上没有指明类型，或者随便写一个拦截点，比如Object，那Mybatis疯了，难道所有对象都去拦截
     * 所以Mybatis会做一次判断，拦截点看看是不是这四个接口里面的方法，不是则不拦截，直接返回目标对象，如果是则需要生成一个代理
     *
     *  该方法在 mybatis 加载核心配置文件时被调用
     */
    @Override
    public Object plugin(Object target) {
        /*
         * 看了这个方法注释，就应该理解，这里的逻辑只有一个，就是让mybatis判断，要不要进行拦截，然后做出决定是否生成一个代理
         *
         * 下面代码什么鬼，就这一句就搞定了？
         * Mybatis判断依据是利用反射，获取这个拦截器 MyInterceptor 的注解 Intercepts和Signature，然后解析里面的值，
         * 1 先是判断要拦截的对象是四个类型中 Executor、StatementHandler、ParameterHandler、 ResultSetHandler 的哪一个
         * 2 然后根据方法名称和参数(因为有重载)判断对哪一个方法进行拦截  Note：mybatis可以拦截这四个接口里面的任一一个方法
         * 3 做出决定，是返回一个对象呢还是返回目标对象本身(目标对象本身就是四个接口的实现类，我们拦截的就是这四个类型)
         *
         * 好了，理解逻辑我们写代码吧~~~  What !!! 要使用反射，然后解析注解，然后根据参数类型，最后还要生成一个代理对象
         * 我一个小白我怎么会这么高大上的代码嘛，怎么办？
         *
         * 那就是使用下面这句代码吧  哈哈
         * mybatis 早就考虑了这里的复杂度，所以提供这个静态方法来实现上面的逻辑
         */
        return Plugin.wrap(target, this);
    }

    /**
     * 这个方法最好理解，如果我们拦截器需要用到一些变量参数，而且这个参数是支持可配置的，
     *  类似Spring中的@Value("${}")从application.properties文件获取
     * 这个时候我们就可以使用这个方法
     *
     * 如何使用？
     * 只需要在 mybatis 配置文件中加入类似如下配置，然后 {@link Interceptor#setProperties(Properties)} 就可以获取参数
     *      <plugin interceptor="liu.york.mybatis.study.plugin.MyInterceptor">
     *           <property name="username" value="LiuYork"/>
     *           <property name="password" value="123456"/>
     *      </plugin>
     *      方法中获取参数：properties.getProperty("username");
     *
     * 问题：为什么要存在这个方法呢，比如直接使用 @Value("${}") 获取不就得了？
     * 原因是 mybatis 框架本身就是一个可以独立使用的框架，没有像 Spring 这种做了很多依赖注入的功能
     *
     *  该方法在 mybatis 加载核心配置文件时被调用 
     */
    @Override
    public void setProperties(Properties properties) {
        String username = properties.getProperty("username");
        String password = properties.getProperty("password");
        // TODO: 2019/2/28  业务逻辑处理...
    }
}

接下来我们看看 Plugin 类
代码案例2

package org.apache.ibatis.plugin;

/**
 * Plugin 类其实就是一个代理类，因为它实现了jdk动态代理接口 InvocationHandler
 * 我们核心只需要关注两个方法
 * wrap：
 *      如果看懂了代码案例1的例子，那么这个方法很理解，这个方法就是 mybatis 提供给开发人员使用的一个工具类方法，
 *      目的就是帮助开发人员省略掉 反射解析注解 Intercepts 和 Signature，有兴趣的可以去看看源码 Plugin#getSignatureMap 方法
 *
 * invoke：
 *      这个方法就是根据 wrap 方法的解析结果，判断当前拦截器是否需要进行拦截，
 *      如果需要拦截：将 目标对象+目标方法+目标参数 封装成一个 Invocation 对象，给我们自定义的拦截器 MyInterceptor 的 intercept 方法
 *                   这个时候就刚好对应上了上面案例1中对 intercept 方法的解释了，它就是我们要处理自己逻辑的方法，
 *                   处理好了之后是否需要调用目标对象的方法，比如上面说的 打印了sql语句，是否还要查询数据库呢？答案是肯定的
 *      如果不需要拦截：则直接调用目标对象的方法
 *                   比如直接调用 Executor 的 update 方法进行更新数据库
 *
 */
class Plugin implements InvocationHandler {

    public static Object wrap(Object target, Interceptor interceptor) {
        // 省略
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 省略
    }
}

Plugin的wrap方法，它根据当前的Interceptor上面的注解定义哪些接口需要拦截，然后判断当前目标对象是否有实现对应需要拦截的接口，如果没有则返回目标对象本身，如果有则返回一个代理对象。而这个代理对象的InvocationHandler正是一个Plugin。所以当目标对象在执行接口方法时，如果是通过代理对象执行的，则会调用对应InvocationHandler的invoke方法，也就是Plugin的invoke方法。所以接着我们来看一下该invoke方法的内容。这里invoke方法的逻辑是：如果当前执行的方法是定义好的需要拦截的方法，则把目标对象、要执行的方法以及方法参数封装成一个Invocation对象，再把封装好的Invocation作为参数传递给当前拦截器的intercept方法。如果不需要拦截，则直接调用当前的方法。Invocation中定义了定义了一个proceed方法，其逻辑就是调用当前方法，所以如果在intercept中需要继续调用当前方法的话可以调用invocation的procced方法。

#### 二级缓存使用存在的风险？

多表查询：例如在UserMapper.xml中有大多数针对user表的操作。但是在一个XXXMapper.xml中，还有针对user单表的操作。这会导致user在两个命名空间下的数据不一致。如果在UserMapper.xml中做了刷新缓存的操作，在XXXMapper.xml中缓存仍然有效，如果有针对user的单表查询，使用缓存的结果可能会不正确。

分布式：在分布式环境中，某条查询语句的缓存存在了机器A上，此时机器B再次查询该语句，之前存储在机器A上的缓存对于机器B来说并不能生效；另外，如果机器B修改了表的数据，机器A上的缓存并不能被清除，这时候机器A再读取就会造成脏读。

不推荐使用Mybatis的二级缓存。

#### 内省和反射的区别？

反射就是运行时获取一个类的所有信息，可以获取到.class的任何定义的信息（包括成员 变量，成员方法，构造器等）可以操纵类的字段、方法、构造器等部分。
内省基于反射实现，主要用于操作JavaBean，通过内省 可以获取bean的getter/setter。

内省和反射的操作也有很大不同，内省是先得到属性描述器PropertyDecriptor后再进行各种操作，反射则是先得到类的字节码Class后再进行各种操作的。

内省：处理ResultSet返回数据时

反射：设置sql语句的参数时

动态代理：JDK动态代理：getMapper()方法、插件实现（拦截器）

​					CGLIB动态代理：延迟加载



