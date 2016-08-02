/* This class is the Test DAta FActory class for SOSL project.
 *
 * Functionality: this class will Create lead,account,contact records 
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     21/03/2016   Basic Functionality Acheived 
 *
 */
 public class TestDataFactory_SOSL {
     public static List<Contact> createTestRecordContacts(
                                                         Integer numberOfContacts, 
                                                         String FirstName, 
                                                         String LastName
                                                        ){
        // Create test record for Contacts 
        
        List<Contact> listContacts=new List<Contact>();
        for( Integer indexI = 0 ; indexI < numberOfContacts ; indexI++ ) {
            Contact objContact = new Contact(FirstName = FirstName + indexI,
                                             LastName = LastName + indexI,
                                             Email = indexI + 'email@gmail.com',
                                             MobilePhone = '132' + indexI
                                            );
            listContacts.add(objContact);
        }
        return listContacts;
    }
}