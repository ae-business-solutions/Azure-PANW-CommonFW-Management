azure-region           = "westus2"
mgmt-prefix            = "mgmt-group"
default-tags           = { environment = "prod", division = "IT" }
mgmt-supernet          = ["10.255.0.0/16"]
mgmt-management-subnet = "10.255.0.0/24"
transit-public-subnet  = "10.110.129.0/24"
transit-private-subnet = "10.110.0.0/24"
management-external    = ["168.63.129.16/32"] # Note that 168.63.129.16/32 should always be included as that is the range that Azure health checks originate from.
management-internal    = ["10.255.0.0/16", "10.110.0.0/16", "10.222.0.0/16"]
panorama-ip            = "10.255.0.10"    #IP address for Panorama's management interface, note that Azure reserves the first 3 IPs in any range for Azure use only, see https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq
dgname                 = "Azure-NGFW"     #Device Group Name
tplname                = "Azure-Template" #Template Name (this creates both the base template and the template stack)