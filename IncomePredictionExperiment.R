// This code requires the Nuget package Microsoft.AspNet.WebApi.Client to be installed.
// Instructions for doing this in Visual Studio:
  // Tools -> Nuget Package Manager -> Package Manager Console
// Install-Package Microsoft.AspNet.WebApi.Client

using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace CallRequestResponseService
{
  
  public class StringTable
  {
    public string[] ColumnNames { get; set; }
    public string[,] Values { get; set; }
  }
  
  class Program
  {
    static void Main(string[] args)
    {
      InvokeRequestResponseService().Wait();
    }
    
    static async Task InvokeRequestResponseService()
    {
      using (var client = new HttpClient())
      {
        var scoreRequest = new
        {
          
          Inputs = new Dictionary<string, StringTable> () { 
            { 
              "input1", 
              new StringTable() 
              {
                ColumnNames = new string[] {"Age", "Workclass", "Fnlwgt", "Education", "Education-num", "Marital-status", "Occupation", "Relationship", "Race", "Sex", "Capital-gain", "Capital-loss", "Hours-per-week", "Native-country", "Income"},
                Values = new string[,] {  { "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" },  { "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" },  }
              }
            },
          },
          GlobalParameters = new Dictionary<string, string>() {
          }
        };
        const string apiKey = "abc123"; // Replace this with the API key for the web service
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue( "Bearer", apiKey);
        
        client.BaseAddress = new Uri("https://ussouthcentral.services.azureml.net/workspaces/8a50acb2f4394e468f389f79a3e23ced/services/88719c0821e94a47954e4cb25b482f73/execute?api-version=2.0&details=true");
        
        // WARNING: The 'await' statement below can result in a deadlock if you are calling this code from the UI thread of an ASP.Net application.
        // One way to address this would be to call ConfigureAwait(false) so that the execution does not attempt to resume on the original context.
        // For instance, replace code such as:
          //      result = await DoSomeTask()
        // with the following:
          //      result = await DoSomeTask().ConfigureAwait(false)
        
        
        HttpResponseMessage response = await client.PostAsJsonAsync("", scoreRequest);
        
        if (response.IsSuccessStatusCode)
        {
          string result = await response.Content.ReadAsStringAsync();
          Console.WriteLine("Result: {0}", result);
        }
        else
        {
          Console.WriteLine(string.Format("The request failed with status code: {0}", response.StatusCode));
          
          // Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
          Console.WriteLine(response.Headers.ToString());
          
          string responseContent = await response.Content.ReadAsStringAsync();
          Console.WriteLine(responseContent);
        }
      }
    }
  }
}

Python
import urllib2
# If you are using Python 3+, import urllib instead of urllib2

import json 


data =  {
  
  "Inputs": {
    
    "input1":
    {
      "ColumnNames": ["Age", "Workclass", "Fnlwgt", "Education", "Education-num", "Marital-status", "Occupation", "Relationship", "Race", "Sex", "Capital-gain", "Capital-loss", "Hours-per-week", "Native-country", "Income"],
      "Values": [ [ "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" ], [ "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" ], ]
    },        },
  "GlobalParameters": {
  }
}

body = str.encode(json.dumps(data))

url = 'https://ussouthcentral.services.azureml.net/workspaces/8a50acb2f4394e468f389f79a3e23ced/services/88719c0821e94a47954e4cb25b482f73/execute?api-version=2.0&details=true'
api_key = 'abc123' # Replace this with the API key for the web service
headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ api_key)}

req = urllib2.Request(url, body, headers) 

try:
  response = urllib2.urlopen(req)

# If you are using Python 3+, replace urllib2 with urllib.request in the above code:
# req = urllib.request.Request(url, body, headers) 
# response = urllib.request.urlopen(req)

result = response.read()
print(result) 
except urllib2.HTTPError, error:
  print("The request failed with status code: " + str(error.code))

# Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
print(error.info())

print(json.loads(error.read()))                 
R
library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()


req = list(
  
  Inputs = list(
    
    
    "input1" = list(
      "ColumnNames" = list("Age", "Workclass", "Fnlwgt", "Education", "Education-num", "Marital-status", "Occupation", "Relationship", "Race", "Sex", "Capital-gain", "Capital-loss", "Hours-per-week", "Native-country", "Income"),
      "Values" = list( list( "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" ),  list( "0", "value", "0", "value", "0", "value", "value", "value", "value", "value", "0", "0", "0", "value", "value" )  )
    )                ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)

body = enc2utf8(toJSON(req))
api_key = "abc123" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/8a50acb2f4394e468f389f79a3e23ced/services/88719c0821e94a47954e4cb25b482f73/execute?api-version=2.0&details=true",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

print("Result:")
result = h$value()
print(fromJSON(result))

