{"objectClass":"NSDictionary","root":{"objectClass":"MindNode","ID":"X8321","rootPoint":{"objectClass":"CGPoint","x":380.97427903351524,"y":960},"lineColorHex":"#BBBBBB","children":{"0":{"objectClass":"MindNode","ID":"3DL2Y","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"22L1G","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"LIX32","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"2HUUR","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"6YT77","lineColorHex":"#37C45A","text":"基于Statement ID"},"1":{"objectClass":"MindNode","ID":"8LC8I","lineColorHex":"#37C45A","text":"基于Mapper接口"},"objectClass":"NSArray"},"text":"提供接口API来操纵数据库"},"objectClass":"NSArray"},"text":"接口层"},"1":{"objectClass":"MindNode","ID":"28S66","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"QX9BN","lineColorHex":"#37C45A","text":"参数映射、SQL解析、SQL执行、结果集处理和映射"},"objectClass":"NSArray"},"text":"数据处理层"},"2":{"objectClass":"MindNode","ID":"4IX5T","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"R6668","lineColorHex":"#37C45A","text":"连接管理、事务管理、配置加载、缓存处理"},"objectClass":"NSArray"},"text":"框架支撑层"},"objectClass":"NSArray"},"text":"架构设计"},"1":{"objectClass":"MindNode","ID":"7V312","lineColorHex":"#37C45A","text":"主要架构及其相互关系"},"2":{"objectClass":"MindNode","ID":"YPWWS","lineColorHex":"#37C45A","children":{"0":{"objectClass":"MindNode","ID":"PL56O","lineColorHex":"#37C45A","text":"加载配置并初始化文件"},"1":{"objectClass":"MindNode","ID":"RO79P","lineColorHex":"#37C45A","text":"接收调用请求"},"2":{"objectClass":"MindNode","ID":"CC4FB","lineColorHex":"#37C45A","text":"处理操作请求"},"3":{"objectClass":"MindNode","ID":"UPDSM","lineColorHex":"#37C45A","text":"返回处理结果"},"objectClass":"NSArray"},"text":"总体流程"},"objectClass":"NSArray"},"text":"架构原理"},"1":{"objectClass":"MindNode","ID":"257H0","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"1H114","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"O3I8W","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"7UR28","lineColorHex":"#BF58F5","text":"初始化前：读取配置文件，字节输入流"},"1":{"objectClass":"MindNode","ID":"3DWM3","lineColorHex":"#BF58F5","text":"初始化：解析配置文件，封装Configuration对象，创建DefaultSqlSession对象"},"objectClass":"NSArray"},"text":"初始化"},"1":{"objectClass":"MindNode","ID":"ND45S","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"881A2","lineColorHex":"#BF58F5","text":"生产DefaultSqlSession实例对象 设置事务 创建Executor对象"},"1":{"objectClass":"MindNode","ID":"9SPDP","lineColorHex":"#BF58F5","text":"根据statementid从configuration中获取到指定的MappedStatment对象，调用Executor中的方法进行处理"},"objectClass":"NSArray"},"text":"执行sql流程"},"2":{"objectClass":"MindNode","ID":"8DGFL","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"H4ISM","lineColorHex":"#BF58F5","text":"query"},"1":{"objectClass":"MindNode","ID":"75BCK","lineColorHex":"#BF58F5","text":"update"},"objectClass":"NSArray"},"text":"Executor"},"3":{"objectClass":"MindNode","ID":"K82B6","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"FW472","lineColorHex":"#BF58F5","text":"设置参数（ParameterHandler）"},"1":{"objectClass":"MindNode","ID":"8SA61","lineColorHex":"#BF58F5","text":"解析resultSet，返回List结果集（ResultSetHandler）"},"objectClass":"NSArray"},"text":"StatementHandler"},"objectClass":"NSArray"},"text":"传统方式"},"1":{"objectClass":"MindNode","ID":"Y3J14","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"E83I4","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"0GOY4","lineColorHex":"#BF58F5","text":"使用JDK动态代理对mapper接口产生代理对象"},"objectClass":"NSArray"},"text":"getMapper()"},"1":{"objectClass":"MindNode","ID":"5W850","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"ZLF74","lineColorHex":"#BF58F5","text":"调用sqlsession中的方法"},"objectClass":"NSArray"},"text":"invoke"},"objectClass":"NSArray"},"text":"Mapper代理方式"},"2":{"objectClass":"MindNode","ID":"7JCRY","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"X88TB","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"9S06X","lineColorHex":"#BF58F5","text":"含义，属于创建类模式"},"1":{"objectClass":"MindNode","ID":"2PJ2X","lineColorHex":"#BF58F5","text":"与工厂模式的区别"},"2":{"objectClass":"MindNode","ID":"J5L8F","lineColorHex":"#BF58F5","text":"创建步骤"},"3":{"objectClass":"MindNode","ID":"1DU37","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"TV794","lineColorHex":"#BF58F5","text":"例：Configuration"},"objectClass":"NSArray"},"text":"在Mybatis中的体现"},"objectClass":"NSArray"},"text":"构建者模式"},"1":{"objectClass":"MindNode","ID":"588K7","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"X3DNA","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"X6E5K","lineColorHex":"#BF58F5","text":"例：SqlSession的创建"},"objectClass":"NSArray"},"text":"简单工厂模式在Mybatis中的体现"},"1":{"objectClass":"MindNode","ID":"5X6BF","lineColorHex":"#BF58F5","text":"含义，创建型模式"},"objectClass":"NSArray"},"text":"工厂模式"},"2":{"objectClass":"MindNode","ID":"8P3GI","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"LRT87","lineColorHex":"#BF58F5","text":"结构型模式"},"1":{"objectClass":"MindNode","ID":"1K7X3","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"KIN87","lineColorHex":"#BF58F5","text":"静态代理"},"1":{"objectClass":"MindNode","ID":"56EE9","lineColorHex":"#BF58F5","children":{"0":{"objectClass":"MindNode","ID":"8R45S","lineColorHex":"#BF58F5","text":"getMapper()"},"objectClass":"NSArray"},"text":"动态代理"},"objectClass":"NSArray"},"text":"类型"},"objectClass":"NSArray"},"text":"代理模式"},"objectClass":"NSArray"},"text":"设计模式"},"objectClass":"NSArray"},"text":"源码剖析"},"objectClass":"NSArray"},"text":"Mybatis","expandLeftEnable":true}}