/* ****************************************************************************
 * This class is the Test class for QueryBuilder Viusalforce PAge
 *
 * Functionality: this class acts as Test Class
 *   Different Test Cases Are designed And asserted
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     4/19/2016   All Functionality Acheived 
 *
 * *****************************************************************************/
@istest public class TestDynamicApex {

    public static String CONTACT = 'contact';
    public static String ACCOUNT = 'account';
    public static String FIRST_NAME = 'Rahim';
    public static String LAST_NAME = 'mulla';

    //This testmethod checks whether objects are populated in picklist.
    static testMethod void testInitializationOfPage() {

        //Declaration
        Set<String> fnotSelected = new Set<String>();
        QueryBuilder objQueryBuilder = new QueryBuilder();

        //actual testing
        Test.startTest();
        fnotSelected = objQueryBuilder.fNotSelected;
        system.debug(fnotSelected);
        Test.stopTest();

        //Result Asserts
        system.assertNotEquals(0, fnotSelected.size());
    }

    //This method checks Valid Query and result is displayed
    static testmethod void testQueryBuilderWithGoodInput(){

        //Declaration And data Creation
        contact objcontact = new Contact(firstname = FIRST_NAME, lastName = LAST_NAME, test__c = FIRST_NAME);
        List<Contact> listContact = new List<Contact>();
        listContact = TestDataFactory_SOSL.createTestRecordContacts(10, 'rahim', LAST_NAME);
        insert listContact;
        insert objcontact;
        List<String> searchResultsIds = new List<String>();
        searchResultsIds.add(objcontact.Id);
        for (Contact objContactId : listContact) {
            searchResultsIds.add(objContactId.Id);
        }

        //Setting Result for SOSL Test CLASS
        Test.setFixedSearchResults(searchResultsIds);

        List<SelectOption> listOptions = new List<SelectOption>();
        QueryBuilder objQueryBuilder = new QueryBuilder();
        Set<String> fnotSelected = new Set<String>();
        Set<String> fSelected = new Set<String>();
        listOptions = objQueryBuilder.fnsOptions;
        objQueryBuilder.searchText = FIRST_NAME;
        objQueryBuilder.sfields.add(CONTACT);
        objQueryBuilder.sfields.add(ACCOUNT);
        objQueryBuilder.addFields();

        system.assertEquals(objQueryBuilder.fSelected.size(), 2);
        system.assertEquals(objQueryBuilder.searchText, FIRST_NAME);

        fnotSelected = objQueryBuilder.fnotSelected;
        fSelected = objQueryBuilder.fSelected;

        //actual testing
        Test.startTest();
        objQueryBuilder.myQueryData();
        Test.stopTest();

        //Result Asserts
        List<QueryBuilder.searchResultRow> listSearchResultRow = new List<QueryBuilder.searchResultRow>();
        listSearchResultRow = objQueryBuilder.searchResults;
        system.assertNotEquals(0, listSearchResultRow.size());
    }

    //This Method cheks for if no Existing Record Present
    static testmethod void testQueryBuilderWithNoExistingRecords(){

        //Declaration And data Creation
        List<SelectOption> listOptions = new List<SelectOption>();
        QueryBuilder objQueryBuilder = new QueryBuilder();
        Set<String> fnotSelected = new Set<String>();
        Set<String> fSelected = new Set<String>();
        listOptions=objQueryBuilder.fnsOptions;
        objQueryBuilder.searchText = 'Abdul';
        objQueryBuilder.sfields.add(CONTACT);
        objQueryBuilder.sfields.add(ACCOUNT);
        objQueryBuilder.addFields();

        system.assertEquals(objQueryBuilder.fSelected.size(), 2);
        system.assertEquals(objQueryBuilder.searchText, 'Abdul');
        
        fnotSelected = objQueryBuilder.fnotSelected;
        fSelected = objQueryBuilder.fSelected;

        //Actual testing
        Test.startTest();
        objQueryBuilder.myQueryData();
        test.stopTest();

        //Result Asserts
        List<QueryBuilder.searchResultRow> listSearchResultRow = new List<QueryBuilder.searchResultRow>();
        listSearchResultRow = objQueryBuilder.searchResults;
        system.assertEquals(true,listSearchResultRow.isEmpty());
    }

        //This testmethod checks whether Proper Error message is displayed when No object selected.
        static testmethod void testQueryBuilderWithOutObject(){

        //Declaration And data Creation
        List<SelectOption> listOptions = new List<SelectOption>();
        QueryBuilder objQueryBuilder = new QueryBuilder();
        Set<String> fnotSelected = new Set<String>();
        Set<String> fSelected = new Set<String>();
        listOptions=objQueryBuilder.fnsOptions;
        objQueryBuilder.searchText = 'Abdul';
        objQueryBuilder.addFields();

        system.assertEquals(objQueryBuilder.fSelected.size(), 0);
        system.assertEquals(objQueryBuilder.searchText, 'Abdul');
        
        fnotSelected = objQueryBuilder.fnotSelected;
        fSelected = objQueryBuilder.fSelected;

        //Actual testing
        Test.startTest();
        objQueryBuilder.myQueryData();
        test.stopTest();

        //Result Asserts
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());

        // Check the error message in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
            if(message.getSummary() == 'Please Select An sObject'
                && message.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;        
            }
        }

        System.assertEquals(messageFound,true);

    }
    
    static testmethod void testQueryBuilderWithInvalidSearchText(){

        //Declaration And data Creation
        List<SelectOption> listOptions = new List<SelectOption>();
        QueryBuilder objQueryBuilder = new QueryBuilder();
        Set<String> fnotSelected = new Set<String>();
        Set<String> fSelected = new Set<String>();
        listOptions=objQueryBuilder.fnsOptions;
        objQueryBuilder.searchText = 'A';
        objQueryBuilder.sfields.add(CONTACT);
        objQueryBuilder.sfields.add(ACCOUNT);
        objQueryBuilder.addFields();

        objQueryBuilder.rfields.add(ACCOUNT);
        objQueryBuilder.removeFields();

        system.assertEquals(objQueryBuilder.fSelected.size(), 1);
        system.assertEquals(objQueryBuilder.searchText, 'A');
        
        fnotSelected = objQueryBuilder.fnotSelected;
        fSelected = objQueryBuilder.fSelected;

        //Actual testing
        Test.startTest();
        objQueryBuilder.myQueryData();
        test.stopTest();

        //Result Asserts
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());

        // Check the error message in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
            if(message.getSummary() == 'Please enter at least two characters..'
                && message.getSeverity() == ApexPages.Severity.ERROR) {
                messageFound = true;        
            }
        }

        System.assertEquals(messageFound, True);

    }
}