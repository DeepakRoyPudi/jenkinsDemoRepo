/****************************************************************************************************
 * This class is the Controller class for QueryBuilderPage VisualForce Page.
 *
 * Functionality: this class acts as Controller
 *   This Controller is just used to initialize Picklist, declare Variables
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     4/15/2016   All Functionality Acheived 
 *
 *****************************************************************************************************/
public class QueryBuilder {
    
    public map<string,schema.SObjectType> mFields{get; set;}
    public List<SelectOption>fsOptions {get;set;}
    public List<SelectOption>fnsOptions {get;set;}
    public List<SelectOption>listLimitOption {get;set;}
    public List<SelectOption>listOrderOption {get;set;}
    public List<String>fields {get; set;}
    public List<String>sfields {get; set;}
    public List<String>rfields {get; set;}
    public Set<String>fSelected {get; set;}
    public Set<String>fNotSelected {get; set;}
    public String query{get; set;}
    public String searchText{get; set;}
    public List<searchResultRow> searchResults{get;set;}
    public list<String> myFields{ get; set;}
    public Integer limits {get;set;}
    public String order {get;set;}
    String PARAMETERS = '(Id, Name ORDER BY Name ';

    public QueryBuilder() {
        myFields = new list<string>();    
        searchResults = new List<searchResultRow>();
        mFields = new map<string,schema.SObjectType>();
        fsOptions = new List<SelectOption>();
        fnsOptions = new List<SelectOption>();
        listLimitOption = new List<SelectOption>();
        listOrderOption = new List<SelectOption>();
        fields = new list<String>();
        sfields = new list<String>();
        rfields = new list<String>();
        fNotSelected = new set<String>();
        fSelected = new set<String>();
        mFields = Schema.getGlobalDescribe();
        selectOption n = new selectOption('None','--None--');
        Details();
        listLimitOption.add(new SelectOption('500', '500'));
        listLimitOption.add(new SelectOption('10', '10'));
        listLimitOption.add(new SelectOption('50', '50'));
        listLimitOption.add(new SelectOption('100', '100'));
        listLimitOption.add(new SelectOption('1000', '1000'));
        listLimitOption.add(new SelectOption('2000', '2000'));
        listOrderOption.add(new SelectOption('ASC', 'Ascending'));
        listOrderOption.add(new SelectOption('DESC', 'Descending'));
        limits = 500;
        order = 'ASC';
    } 

    public void Details() {
        fnsOptions.clear();
        fsOptions.clear();    
        fields.addAll(mFields.keySet());
        fields.sort();

        fNotSelected.addAll(fields);
        show();
    } 

    public void show() {
        fnsOptions.clear();
        fsOptions.clear();
        for(String s: fNotSelected) {
            selectOption so = new selectOption(s,s);
            fnsOptions.add(so); 
        }

        for(String ss: fSelected) {
            selectOption so = new selectOption(ss,ss);
            fsOptions.add(so);
        }
    }

    public void addFields() {
        fNotSelected.removeAll(sfields);
        fSelected.addAll(sfields);
        show();
    }

    public void removeFields() {
        fNotSelected.AddAll(rfields);
        fSelected.removeAll(rfields);
        show();
    }

    public class searchResultRow {
        public string sObjectTypeName {get;set;}
        public sObject record {get;set;}
       
        public searchResultRow(sObject pObject) {
            record = pObject;
            sObjectTypeName = pObject.getSObjectType().getDescribe().getLabel();
        }
    } 

    public void myQueryData() {
        searchResults.clear();
        if(searchText.length() > 1) {

            String listObjects = '';
            query='FIND {' + searchText + '} IN ALL FIELDS RETURNING ';
            myfields.addAll(fSelected);

            for(string s: fSelected) {
                if(listObjects == '' || listObjects == null) {
                    listObjects = s + PARAMETERS + order +')';
                }
                else {
                    listObjects = listObjects+','+s + PARAMETERS + order +')';
                }
            }

            if(listObjects.length()>0) {
                query = query + listObjects + ' LIMIT ' + limits;
            }
            else{
                query='';
                apexPages.addmessage(
                                    new apexpages.message(
                                                            apexpages.severity.Error, 
                                                            'Please Select An sObject'
                                                            )
                                    );
                return;
            }

            List<List<sObject>> searchList = search.query(query);
            for(list<sObject> objectList : searchList) {
                for(sObject obj : objectList) {
                    searchResults.add(new searchResultRow(obj));
                }
            }

            if(searchResults.size() == 0) {
                apexPages.addmessage(
                                    new apexpages.message(
                                                            apexpages.severity.Error, 
                                                            'Sorry, no results returned with matching string..'
                                                            )
                                    );
                return;
            }

        }
        else {
            apexPages.addmessage(
                                new apexpages.message(
                                                        apexpages.severity.Error, 
                                                        'Please enter at least two characters..'
                                                    )
                                );
            return;
        }
    }
}