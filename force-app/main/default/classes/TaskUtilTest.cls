@isTest
public class TaskUtilTest {
    @isTest(SeeAllData=true) static void TaskUtilTestMethod_ONE (){
        String TaskPriority = TaskUtil.getTaskPriority('NY');
        System.assertEquals('Normal', TaskPriority);
    }
     @isTest(SeeAllData=true) static void TaskUtilTestMethod_TWO (){
        String TaskPriority = TaskUtil.getTaskPriority('ca');
        System.assertEquals('High', TaskPriority);
    }
     @isTest(SeeAllData=true) static void TaskUtilTestMethod_Three (){
        String TaskPriority = TaskUtil.getTaskPriority('NYC');
        System.assertEquals(null, TaskPriority);
    }
     @isTest(SeeAllData=true) static void TaskUtilTestMethod_four (){
        String TaskPriority = TaskUtil.getTaskPriority('');
        System.assertEquals(null, TaskPriority);
    }
}