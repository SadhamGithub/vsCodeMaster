/**
 * Author : Natarajan Periyasamy
 * Date: 10/01/2019
 * Class: SObjectUtility.cls
 */

public class SObjectUtility {

    private static Map<Id, RecordType> reverseCache;

    private static Map<String, Map<String, RecordType>> recordTypeByNameCache;

    private static Map<String, Map<String, RecordType>> recordTypeCache {

        get {

            if (recordTypeCache == null) {

                recordTypeCache = new Map<String, Map<String, RecordType>>();
                recordTypeByNameCache = new Map<String, Map<String, RecordType>>();
                
                reverseCache = new Map<Id, RecordType>();

                List<RecordType> allRecTypes = [SELECT Id, DeveloperName, Name, SobjectType,
                                                       IsActive, BusinessProcessId, Description,
                                                       NamespacePrefix
                                                FROM RecordType];

                for (RecordType r : allRecTypes) {

                    if(recordTypeCache.get(r.SobjectType) == null)
                        recordTypeCache.put(r.SobjectType, new Map<String, RecordType>());

                    if(recordTypeByNameCache.get(r.SobjectType) == null)
                        recordTypeByNameCache.put(r.SobjectType, new Map<String, RecordType>());

                    recordTypeCache.get(r.SobjectType).put(r.DeveloperName, r);
                    recordTypeByNameCache.get(r.SobjectType).put(r.Name, r);
                    reverseCache.put(r.Id, r);
                }
            }

            return recordTypeCache;
        }

        private set;
    }

    public static Id getRecordTypeIdByDevName(String sObjectName, String developerName) {

        RecordType rt = recordTypeCache.get(sObjectName).get(developerName);

        if (rt == null)
            throw new RecordTypeCacheException('RecordType \'' + developerName + '\' for \''
                                               + sObjectName + '\' does not exist.');

        return rt.Id;
    }

    public static Id getRecordTypeIdByName(String sObjectName, String recTypeName) {

        RecordType rt = recordTypeByNameCache.get(sObjectName).get(recTypeName);

        if (rt == null)
            throw new RecordTypeCacheException('RecordType \'' + recTypeName + '\' for \''
                                               + sObjectName + '\' does not exist.');

        return rt.Id;
    }


    public static String getRecordTypeDeveloperNameById(Id recTypeId) {

        Map<String, Map<String, RecordType>> unusedCache = recordTypeCache;

        RecordType rt = reverseCache.get(recTypeId);

        if (rt == null)
            throw new RecordTypeCacheException('RecordType with Id \'' + recTypeId + '\' does not exist.');

        return rt.DeveloperName;
    }

    public static String getQueryStringForSObject(String objName){
        
        SObjectType objTokenFile = Schema.getGlobalDescribe().get(objName);

        DescribeSObjectResult objDeffile = objTokenFile.getDescribe();
        
        Map<String, SObjectField> fieldsFile = objDeffile.fields.getMap();
        string fieldLstFile='';
        Set<String> fieldSetFiles = fieldsFile.keySet();

        for(String s:fieldSetFiles) {
            SObjectField fieldToken = fieldsFile.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            fieldLstFile=fieldLstFile+selectedField.getName()+',';
        }

        fieldLstFile= fieldLstFile.removeEnd(',');

        return fieldLstFile;
    }

    public class RecordTypeCacheException extends Exception{}
}