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

**很明显，调用无参构造方法实例化对象要比调用有参构造的更加简单、方便，所以在日后的所有开发之中，凡是有简单****Java****类出现的地方，都一定要提供无参构造。**

2、SpringBean的生命周期

3、什么是springbean？与bean的区别？

4、