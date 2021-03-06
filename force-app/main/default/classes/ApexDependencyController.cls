/**
 * Created by kgoncalv on 4/16/2020.
 */

public without sharing class ApexDependencyController {
    @AuraEnabled(cacheable=true)
    public static List<ApexClass> getUnReferencedClasses() {
        ApexDependencyWrapper classesWithDependency = (ApexDependencyWrapper) System.JSON.deserialize(getDependentClasses(), ApexDependencyWrapper.Class);
        List<ApexClass> allClasses = getAllClasses();
        List<String> classesReferenced = convertToListNames(classesWithDependency);
        return findUnReferencedClasses(classesReferenced,allClasses);
    }

    public static String getDependentClasses(){
        //tooling api query cal
        Http httpProtocol = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
                '/services/data/v47.0/tooling/query/?q=' +
                'SELECT+RefMetadataComponentName,RefMetadataComponentId,MetadataComponentName' +
                '+FROM+MetadataComponentDependency' +
                '+WHERE+RefMetadataComponentType=\'ApexClass\'');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        HttpResponse resp = httpProtocol.send(req);
        return resp.getBody();
    }

    public static List<ApexClass> getAllClasses(){
        return [SELECT Id,Name FROM ApexClass WHERE NamespacePrefix = null];
    }

    public static List<String> convertToListNames(ApexDependencyWrapper classDependencies){
        List<String> classesReferenced = new List<String>();
        for (ApexDependencyWrapper.DependencyRecords apexDepRec : classDependencies.records) {
            //filter out any tests that are depedent on classes as expected
            if(!apexDepRec.MetadataComponentName.contains('Test')){
                classesReferenced.add(apexDepRec.RefMetadataComponentName);
            }
        }
        return classesReferenced;
    }
    public static List<ApexClass> findUnReferencedClasses(List<String> classesReferenced, List<ApexClass> allClasses){
        List<ApexClass> classesNotReferenced = new List<ApexClass>();
        //not including test classes
        for (ApexClass apexName : allClasses) {
            if (!classesReferenced.contains(apexName.Name) && !apexName.Name.contains('Test')) {
                classesNotReferenced.add(apexName);
            }
        }
        return classesNotReferenced;
    }
}