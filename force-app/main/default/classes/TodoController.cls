public with sharing class TodoController {
    @AuraEnabled(Cacheable=true)
    public static Todo__c[] getAllTodos() {
        Todo__c[] todos = [
            SELECT
                Id, 
                Name, 
                Description__c, 
                CreatedDate, 
                Category__c, 
                Priority__c, 
                Status__c,
                (SELECT Id, Name, Status__c FROM SubTodos__r)
            FROM Todo__c
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate
            LIMIT 50
        ];
        Sub_Todo__c[] subtodos = todos[0].SubTodos__r;
        return todos;
    }

    @AuraEnabled(Cacheable=true)
    public static Sub_Todo__c[] getAllSubTodos(String recordId) {
        return [
            SELECT
                Id, 
                Name, 
                Status__c,
                Todo__c,
                CreatedDate 
            FROM Sub_Todo__c
            WHERE Todo__c = :recordId
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate
        ];
    }

    @AuraEnabled
    public static Sub_Todo__c saveSubTodo(Sub_Todo__c newsubtodo){
        try{
            insert newsubtodo;
            System.debug('Inserted successfully' + newsubtodo.Id);
            return newsubtodo;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static Sub_Todo__c changeStatus(Boolean status, Id subId){
         
        Sub_Todo__c thisSub = [ SELECT
                                Id, 
                                Name, 
                                Status__c,
                                Todo__c 
                                FROM Sub_Todo__c
                                WHERE Todo__c = :subId
                                WITH SECURITY_ENFORCED
                                ORDER BY Name
                            ];  
        try{
            thisSub.Status__c = status;
            update thisSub;
            System.debug('Updated successfully' + thisSub.Id);
            return thisSub;
        }
        catch(Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }


    @AuraEnabled(Cacheable=true)
    public static Todo__c[] searchTodos(String searchTerm, String searchTermDesc) {
        searchTerm = searchTerm.trim();
        searchTermDesc = searchTermDesc.trim();
        String filterSearch;
        filterSearch = searchTerm + searchTermDesc;
        if (filterSearch == '') {
            return getAllTodos();
        }
        String condition = '';
        if(searchTerm!=''){
            searchTerm = '%' + searchTerm + '%';
            condition += ' AND Name LIKE :searchTerm ';
        }
        if(searchTermDesc!=''){
            searchTermDesc = '%' + searchTermDesc + '%';
            condition += ' AND Description__c LIKE :searchTermDesc ';
        }
       
        String query = 
            'SELECT '+ 
                'Id,'+ 
                'Name,'+ 
                'Description__c,'+ 
                'CreatedDate,'+ 
                'Category__c,'+ 
                'Priority__c,'+ 
                'Status__c'+ 
            ' FROM Todo__c'+ 
            ' WHERE Id!=null '+ condition +
            ' WITH SECURITY_ENFORCED'+
            ' ORDER BY CreatedDate'+
            ' LIMIT 50';
        List<Todo__c> TODOS = Database.query(query);
        return TODOS;
    }

    @AuraEnabled(Cacheable=true)
    public static Todo__c[] filterTodos(String varCat, String varPrior, String varStat) {
        // Return all recs when no search term
        String filter;
        filter = varCat + varPrior + varStat;
        if (filter == '') {
            return getAllTodos();
        }
        String condition = '';
        if(varCat!=''){
            condition += ' AND Category__c =:varCat ';
        }
        if(varPrior!=''){
            condition += ' AND Priority__c =:varPrior ';
        }
        if(varStat!=''){
            condition += ' AND Status__c =:varStat ';
        }
        String query = 
            'SELECT '+ 
                'Id,'+ 
                'Name,'+ 
                'Description__c,'+ 
                'CreatedDate,'+ 
                'Category__c,'+ 
                'Priority__c,'+ 
                'Status__c'+ 
            ' FROM Todo__c'+ 
            ' WHERE Id!=null '+ condition +
            ' WITH SECURITY_ENFORCED'+
            ' ORDER BY CreatedDate'+
            ' LIMIT 50';
        List<Todo__c> TODOS = Database.query(query);
        return TODOS;
    }
}