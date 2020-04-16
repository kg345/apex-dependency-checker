//Class to deserialize the response from Tooling API query
public class ApexDependencyWrapper {
    public List<DependencyRecords> records {get; set;}
    public class DependencyRecords{
        public String RefMetadataComponentName {get; set;} //the referenced class
        public String MetadataComponentName {get; set;} //the class relying on the ref class
        public Id RefMetadataComponentId {get; set;}
    }
}