#### 1、反射技术 - 构造方法

反射获得构造方法cons，cls是Class类型的对象

Constructor<?> cons = cls.getConstructor(String.class, int.class);

Object obj = cons.newInstance("张三", 20); //获得了这个构造如何用？ 为构造方法传递参数

class类里面的提供构造方法

![img](https://images2017.cnblogs.com/blog/776043/201708/776043-20170819223426256-1293379442.png)

 

**使用反射机制也可以取得类之中的构造方法，这个方法在****Class****类之中已经明确定义了：**

**以下两个方法**

**取得一个类的全部构造：**

**public Constructor[] getConstructors() throws SecurityException**

**取得一个类的指定参数构造：**

**public Constructor getConstructor(Class... parameterTypes) throws NoSuchMethodException, SecurityException**

 

**现在发现以上的两个方法返回的都是****java.lang.reflect.Constructor****类的对象。**

**范例：****取得一个类之中的全部构造**

```text
packagecn.mldn.demo;
importjava.lang.reflect.Constructor; //不在java语言包
classPerson { // CTRL + K
publicPerson() {}
publicPerson(String name) {}
publicPerson(String name,intage) {}
}
publicclassTestDemo {
publicstaticvoidmain(String[] args) throwsException {
Class<?> cls = Class.forName("cn.mldn.demo.Person") ; // 取得Class对象
Constructor<?> cons [] = cls.getConstructors() ; // 取得全部构造
for(intx = 0; x < cons.length; x++) {
System.out.println(cons[x]);
}
}
}
```

 

**验证：****在之前强调的一个简单****Java****类必须存在一个无参构造方法**

**范例：****观察没有无参构造的情况**

```text
packagecn.mldn.demo;
classPerson { // CTRL + K
privateString name;
privateintage;
publicPerson(String name,intage) {
this.name= name ;
this.age= age ;
}
@Override
publicString toString() {
return"Person [name="+ name+ ", age="+ age+ "]";
}
}
publicclassTestDemo {
publicstaticvoidmain(String[] args) throwsException {
Class<?> cls = Class.forName("cn.mldn.demo.Person") ; // 取得Class对象
Object obj = cls.newInstance(); // 实例化对象
System.out.println(obj);
}
}
```

　/*在进行spring开发的时候看见---进行构造器注入的时候，若提供了有参的构造方法

则无参数的构造方法必须人为提供，否则系统不会自动提供

*/

**此时程序运行的时候出现了错误提示“****java.lang.InstantiationException****”，因为以上的方式使用反射实例化对象时需要的是类之中要提供无参构造方法，但是现在既然没有了无参构造方法，那么就必须明确的找到一个构造方法，而后利用****Constructor****类之中的新方法实例化对象：**

**·****实例化对象：****public T newInstance(Object... initargs) throws InstantiationException, IllegalAccessException,****IllegalArgumentException, InvocationTargetException**

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
package cn.mldn.demo;

import java.lang.reflect.Constructor;

class Person { // CTRL + K
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    public Person() {
    }
        
    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + "]";
    }
    public void say(){
        System.out.println("hi");
    }
}

public class TestDemo {
    public static void main(String[] args) throws Exception {
        Class<?> cls = Class.forName("cn.mldn.demo.Person"); // 取得Class对象
        // 取得指定参数类型的构造方法
        Constructor<?> cons = cls.getConstructor(String.class, int.class);
        Object obj = cons.newInstance("张三", 20); // 为构造方法传递参数
        System.out.println(obj); // Person [name=张三, age=20]
        Object obj1 = cls.newInstance();//里面不能使用传统的构造函数的装入newInstance("张三", 20)
        Person I = (Person)obj; 
        I.say();// hi
    }
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

**很明显，调用无参构造方法实例化对象要比调用有参构造的更加简单、方便，所以在日后的所有开发之中，凡是有简单**Java类出现的地方，都一定要提供无参构造。

2、SpringBean的生命周期

3、什么是springbean？与bean的区别？

4、Spring引入外部资源文件的方式？

5、什么场景使用同步关键字？

6、Spring中AOP的实现方式？

#### 7、实例化Bean的三种⽅式

⽅式⼀：使⽤⽆参构造函数

在默认情况下，它会通过反射调⽤⽆参构造函数来创建对象。如果类中没有⽆参构造函数，将创建失败。

<!--配置service对象-->

<bean id="userService" class="com.lagou.service.impl.TransferServiceImpl">

</bean>

⽅式⼆：使⽤静态⽅法创建

在实际开发中，我们使⽤的对象有些时候并不是直接通过构造函数就可以创建出来的，它可能在创建的过程 中会做很多额外的操作。此时会提供⼀个创建对象的⽅法，恰好这个⽅法是static修饰的⽅法，即是此种情 况。

例如，我们在做Jdbc操作时，会⽤到java.sql.Connection接⼝的实现类，如果是mysql数据库，那么⽤的就 是JDBC4Connection，但是我们不会去写 JDBC4Connection connection = newJDBC4Connection() ，因 为我们要注册驱动，还要提供URL和凭证信息，⽤ DriverManager.getConnection ⽅法来获取连接。那么在实际开发中，尤其早期的项⽬没有使⽤Spring框架来管理对象的创建，但是在设计时使⽤了⼯⼚模式 解耦，那么当接⼊spring之后，⼯⼚类创建对象就具有和上述例⼦相同特征，即可采⽤此种⽅式配置。

<!--使⽤静态⽅法创建对象的配置⽅式-->

<bean id="userService" class="com.lagou.factory.BeanFactory" factory-method="getTransferService"></bean>

⽅式三：使⽤实例化⽅法创建

此种⽅式和上⾯静态⽅法创建其实类似，区别是⽤于获取对象的⽅法不再是static修饰的了，⽽是类中的⼀ 个普通⽅法。此种⽅式⽐静态⽅法创建的使⽤⼏率要⾼⼀些。在早期开发的项⽬中，⼯⼚类中的⽅法有可能是静态的，也有可能是⾮静态⽅法，当是⾮静态⽅法时，即可 采⽤下⾯的配置⽅式：

<!--使⽤实例⽅法创建对象的配置⽅式-->

<bean id="beanFactory" class="com.lagou.factory.instancemethod.BeanFactory"></bean> 

<bean id="transferService" factory-bean="beanFactory" factory-method="getTransferService"></bean>

#### 8、spring 中的 bean 是线程安全的吗?

spring 管理的 bean 的线程安全跟 bean 的创建作用域和 bean 所在的使用环境是否存在竞态条件有关，spring 并不能保证 bean 的线程安全。

Spring容器中的Bean是否线程安全，容器本身并没有提供Bean的线程安全策略，因此可以说Spring容器中的Bean本身不具备线程安全的特性，但是具体还是要结合具体scope的Bean去研究。

Spring 的 bean 作用域（scope）类型
1、singleton:单例，默认作用域。

2、prototype:原型，每次创建一个新对象。

3、request:请求，每次Http请求创建一个新对象，适用于WebApplicationContext环境下。

4、session:会话，同一个会话共享一个实例，不同会话使用不用的实例。

5、global-session:全局会话，所有会话共享一个实例。

线程安全这个问题，要从单例与原型Bean分别进行说明。

原型Bean
对于原型Bean,每次创建一个新对象，也就是线程之间并不存在Bean共享，自然是不会有线程安全的问题。

单例Bean
对于单例Bean,所有线程都共享一个单例实例Bean,因此是存在资源的竞争。

如果单例Bean,是一个无状态Bean，也就是线程中的操作不会对Bean的成员执行查询以外的操作，那么这个单例Bean是线程安全的。比如Spring mvc 的 Controller、Service、Dao等，这些Bean大多是无状态的，只关注于方法本身。

对于有状态的bean，Spring官方提供的bean，一般提供了通过ThreadLocal去解决线程安全的方法，比如RequestContextHolder、TransactionSynchronizationManager、LocaleContextHolder等。

使用ThreadLocal的好处
使得多线程场景下，多个线程对这个单例Bean的成员变量并不存在资源的竞争，因为ThreadLocal为每个线程保存线程私有的数据。这是一种以空间换时间的方式。

当然也可以通过加锁的方法来解决线程安全，这种以时间换空间的场景在高并发场景下显然是不实际的。