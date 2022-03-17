@isTest
public class TestVerifyDate {
@isTest(SeeAllData=true) static void VerifyDate_TEST_ONE (){
        Date DateResult = VerifyDate.CheckDates(Date.newInstance(1960, 2, 17),Date.newInstance(1960, 3, 10));
        System.assertEquals(Date.newInstance(1960, 3, 10), DateResult);
    }
    @isTest(SeeAllData=true) static void VerifyDate_TEST_TWO (){
        Date DateResult = VerifyDate.CheckDates(Date.newInstance(1960, 2, 17),Date.newInstance(1960, 3, 25));
        System.assertEquals(Date.newInstance(1960, 2, 29), DateResult);
    }
}