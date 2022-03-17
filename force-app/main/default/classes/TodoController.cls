public with sharing class TodoController {
    @AuraEnabled(Cacheable=true)
    public static Todo__c[] getAllTodos() {
        return [
            SELECT
                Id, 
                Name, 
                Description__c, 
                CreatedDate, 
                Category__c, 
                Priority__c, 
                Status__c 
            FROM Todo__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 50
        ];
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
            ' ORDER BY Name'+
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
            ' ORDER BY Name'+
            ' LIMIT 50';
        List<Todo__c> TODOS = Database.query(query);
        return TODOS;
    }
}
