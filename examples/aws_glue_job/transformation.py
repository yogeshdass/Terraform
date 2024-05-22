from awsglue.context import GlueContext
from pyspark.context import SparkContext
from awsglue.context import DynamicFrame
from datetime import datetime

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)

dynamicFrame = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://aws-source/sample.xml"]},
    format="xml",
    format_options={"rowTag": "Job"},
)
jsonFormatSchema = '''{"type":"record","name":"ExternalDeliveryStatus","namespace":"sample","fields":[{"name":"messageHeader","type":{"type":"record","name":"MessageHeader","namespace":"sample.hdr","fields":[{"name":"receiverDetails","type":["null",{"type":"array","items":{"type":"record","name":"ReceiverIdentificationDetails","namespace":"sample.types","fields":[{"name":"physicalReceiver","type":"string"},{"name":"logicalReceiver","type":"string"},{"name":"customerIdentifier","type":["null","string"],"default":null},{"name":"addressType","type":"string"}],"connect.name":"sample.types.ReceiverIdentificationDetails"}}],"default":null},{"name":"physicalSender","type":["null","string"],"default":null},{"name":"logicalSender","type":["null","string"],"default":null},{"name":"sendingApplication","type":"string"},{"name":"messageType","type":"string"},{"name":"versionNumber","type":"string"},{"name":"creationDateTime","type":{"type":"long","connect.version":1,"connect.name":"org.apache.kafka.connect.data.Timestamp","logicalType":"timestamp-millis"}},{"name":"levelStructureCode","type":["null","string"],"default":null},{"name":"interchangeControlReference","type":["null","string"],"default":null},{"name":"functionCode","type":["null","string"],"default":null},{"name":"processMode","type":["null","string"],"default":null}],"connect.name":"sample.hdr.MessageHeader"}},{"name":"messageLevel","type":{"type":"record","name":"MessageLevel","namespace":"sample.mlv","fields":[{"name":"trackingNumber","type":["null",{"type":"record","name":"TrackingNumber","namespace":"sample.mlv.msglvl","fields":[{"name":"value","type":["null","string"],"default":null},{"name":"communicationCounter","type":["null","long"],"default":null}],"connect.name":"sample.mlv.msglvl.TrackingNumber"}],"default":null},{"name":"coverFileTrackingNumber","type":["null","string"],"default":null},{"name":"senderInformation","type":["null",{"type":"record","name":"SenderInformation","namespace":"sample.mlv.msglvl","fields":[{"name":"companyCode","type":["null","string"],"default":null},{"name":"branchCode","type":["null","string"],"default":null},{"name":"departmentCode","type":["null","string"],"default":null},{"name":"modeOfTransport","type":"string"},{"name":"exportImportFlag","type":["null","string"],"default":null}],"connect.name":"sample.mlv.msglvl.SenderInformation"}],"default":null},{"name":"messageNumber","type":["null","string"],"default":null},{"name":"messageReferences","type":["null",{"type":"array","items":{"type":"record","name":"ReferencesDetails","namespace":"sample.types","fields":[{"name":"code","type":"string"},{"name":"value","type":{"type":"array","items":"string"}},{"name":"customerReferenceCode","type":["null","string"],"default":null},{"name":"category","type":["null","string"],"default":null},{"name":"addressType","type":"string"}],"connect.name":"sample.types.ReferencesDetails"}}],"default":null}],"connect.name":"sample.mlv.MessageLevel"}},{"name":"statusInformation","type":{"type":"array","items":{"type":"record","name":"StatusInformation","namespace":"sample.sts","fields":[{"name":"exeptionCode","type":["null","string"],"default":null},{"name":"reasonCode","type":["null","string"],"default":null},{"name":"trigger","type":["null","string"],"default":null},{"name":"addStatusInformation","type":["null",{"type":"record","name":"AddStatusInformation","namespace":"sample.sts.stsinf","fields":[{"name":"creationIdentifier","type":["null","string"],"default":null},{"name":"statusEntryDateTime","type":{"type":"long","connect.version":1,"connect.name":"org.apache.kafka.connect.data.Timestamp","logicalType":"timestamp-millis"}},{"name":"userIdentifier","type":["null","string"],"default":null},{"name":"remarks","type":["null",{"type":"array","items":"string"}],"default":null},{"name":"previousStatusCode","type":["null","string"],"default":null},{"name":"previousReceivedComCounter","type":["null","string"],"default":null}],"connect.name":"sample.sts.stsinf.AddStatusInformation"}],"default":null},{"name":"addAirfreightStatusInformation","type":["null",{"type":"record","name":"AddAirfreightStatusInformation","namespace":"sample.sts.stsinf","fields":[{"name":"cargoIMPCode","type":["null","string"],"default":null},{"name":"carrierCode","type":["null","string"],"default":null},{"name":"flightNumber","type":["null","string"],"default":null},{"name":"arrivalDateTime","type":["null",{"type":"long","connect.version":1,"connect.name":"org.apache.kafka.connect.data.Timestamp","logicalType":"timestamp-millis"}],"default":null}],"connect.name":"sample.sts.stsinf.AddAirfreightStatusInformation"}],"default":null},{"name":"addRoadStatusInformation","type":["null",{"type":"record","name":"AddRoadStatusInformation","namespace":"sample.sts.stsinf","fields":[{"name":"contactName","type":["null","string"],"default":null},{"name":"eventCreator","type":["null","string"],"default":null},{"name":"jobReference","type":["null","string"],"default":null},{"name":"latitude","type":["null","double"],"default":null},{"name":"longitude","type":["null","double"],"default":null},{"name":"kmReading","type":["null","double"],"default":null}],"connect.name":"sample.sts.stsinf.AddRoadStatusInformation"}],"default":null},{"name":"nameAddressDetails","type":["null",{"type":"record","name":"NameAddressDetails","namespace":"sample.types","fields":[{"name":"name","type":["null",{"type":"array","items":"string"}],"default":null},{"name":"street","type":["null",{"type":"array","items":"string"}],"default":null},{"name":"city","type":["null",{"type":"array","items":"string"}],"default":null},{"name":"countryCode","type":["null","string"],"default":null},{"name":"stateCode","type":["null","string"],"default":null},{"name":"state","type":["null","string"],"default":null},{"name":"postOfficeBox","type":["null","string"],"default":null},{"name":"zipCode","type":["null","string"],"default":null},{"name":"customerIdentifier","type":["null","string"],"default":null},{"name":"partyIdentifier","type":["null","string"],"default":null},{"name":"printAddress","type":["null",{"type":"array","items":{"type":"record","name":"Description","fields":[{"name":"value","type":["null","string"],"default":null},{"name":"sequenceNumber","type":["null","int"],"default":null}],"connect.name":"sample.types.Description"}}],"default":null},{"name":"contact","type":["null",{"type":"array","items":{"type":"record","name":"Contact","fields":[{"name":"lastName","type":"string"},{"name":"firstName","type":["null","string"],"default":null},{"name":"contactType","type":["null","string"],"default":null},{"name":"department","type":["null","string"],"default":null},{"name":"actionCode","type":["null","string"],"default":null},{"name":"communication","type":["null",{"type":"array","items":{"type":"record","name":"Communication","namespace":"sample.types.contactdetails","fields":[{"name":"value","type":["null","string"],"default":null},{"name":"communicationType","type":"string"}],"connect.name":"sample.types.contactdetails.Communication"}}],"default":null}],"connect.name":"sample.types.Contact"}}],"default":null},{"name":"references","type":["null",{"type":"array","items":{"type":"record","name":"References","fields":[{"name":"code","type":"string"},{"name":"value","type":{"type":"array","items":"string"}},{"name":"customerReferenceCode","type":["null","string"],"default":null},{"name":"category","type":["null","string"],"default":null}],"connect.name":"sample.types.References"}}],"default":null},{"name":"orderClient","type":["null",{"type":"enum","name":"YesNoFlag","symbols":["N","Y"],"connect.parameters":{"io.confluent.connect.avro.Enum":"sample.types.YesNoFlag","io.confluent.connect.avro.Enum.N":"N","io.confluent.connect.avro.Enum.Y":"Y"}}],"default":null},{"name":"jobNotes","type":["null",{"type":"array","items":{"type":"record","name":"JobNotes","namespace":"sample.types.nameandaddresswithtype","fields":[{"name":"text","type":{"type":"array","items":{"type":"record","name":"Text","namespace":"sample.types","fields":[{"name":"value","type":["null","string"],"default":null},{"name":"textType","type":"string"},{"name":"sequenceNumber","type":["null","long"],"default":null}],"connect.name":"sample.types.Text"}}}],"connect.name":"sample.types.nameandaddresswithtype.JobNotes"}}],"default":null},{"name":"addressType","type":["null","string"],"default":null}],"connect.name":"sample.types.NameAddressDetails"}],"default":null},{"name":"partial","type":["null","sample.types.YesNoFlag"],"default":null},{"name":"quantity","type":["null",{"type":"record","name":"Quantity","namespace":"sample.types","fields":[{"name":"value","type":"double"},{"name":"quantityType","type":["null","string"],"default":null}],"connect.name":"sample.types.Quantity"}],"default":null},{"name":"statusCode","type":"string"}],"connect.name":"sample.sts.StatusInformation"}}},{"name":"deliveryInformation","type":["null",{"type":"record","name":"DeliveryInformation","namespace":"sample.del","fields":[{"name":"containerNumber","type":["null","sample.types.Description"],"default":null},{"name":"containerSealNumber","type":["null",{"type":"array","items":"sample.types.Description"}],"default":null},{"name":"truckerCost","type":["null",{"type":"array","items":{"type":"record","name":"TruckerCost","namespace":"sample.del.delinf","fields":[{"name":"code","type":["null","string"],"default":null},{"name":"name","type":["null","string"],"default":null},{"name":"invoiceAmount","type":{"type":"record","name":"MonetaryAmount","namespace":"sample.types","fields":[{"name":"value","type":"double"},{"name":"currencyCode","type":"string"},{"name":"label","type":["null","string"],"default":null}],"connect.name":"sample.types.MonetaryAmount"}}],"connect.name":"sample.del.delinf.TruckerCost"}}],"default":null}],"connect.name":"sample.del.DeliveryInformation"}],"default":null}],"connect.name":"sample.ExternalDeliveryStatus"}'''

def convert_to_epoch_timestamp(timestamp :str):
    datetime_object = datetime.strptime(timestamp, '%Y%m%d%H%M%S')
    return int(datetime_object.timestamp() * 1000)


def mappings(rec):
    new_rec = {}
    new_rec["messageHeader"] = {}
    new_rec["messageHeader"]["sendingApplication"] = "me"
    new_rec["messageHeader"]["messageType"] = "text"
    new_rec["messageHeader"]["versionNumber"] = "100"
    new_rec["messageHeader"]["creationDateTime"] = convert_to_epoch_timestamp(str(rec["ActionDateTime"]))
    
    new_rec["messageLevel"] = {}
    new_rec["messageLevel"]["trackingNumber"] = {}
    new_rec["messageLevel"]["trackingNumber"]["value"] = str(rec["CustomerReference"])
    
    new_rec["statusInformation"] = [{}]
    new_rec["statusInformation"][0]["statusCode"] = rec["Status"]
    
    new_rec["deliveryInformation"] = {}
    new_rec["deliveryInformation"]["containerNumber"] = {}
    new_rec["deliveryInformation"]["containerNumber"]["value"] = rec["ContainerNumber"]
    new_rec["deliveryInformation"]["containerSealNumber"] = [{}]
    new_rec["deliveryInformation"]["containerSealNumber"][0]["value"] = str(rec["SealNumber"])
    new_rec["deliveryInformation"]["containerSealNumber"][0]["sequenceNumber"] = 1
    
    return new_rec


# Use map to apply MergeAddress to every record
mapped_dynamicFrame = dynamicFrame.map(f = mappings)
mapped_dynamicFrame.show()

df = mapped_dynamicFrame.toDF()
df.write.format("avro").option("avroSchema",jsonFormatSchema).save(F"s3://aws-sink/{datetime.now().strftime('%Y-%m-%d-%H%M%S')}")

job.commit()