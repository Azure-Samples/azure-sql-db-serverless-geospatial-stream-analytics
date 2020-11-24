using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;

namespace GTFS_To_EH
{
    class RealTimeManager
    {        
        private readonly HttpClient _client = new HttpClient();
        private readonly string _busRealTimeFeedUrl = Environment.GetEnvironmentVariable("RealTimeFeedUrl");
        private readonly string _connectionString = Environment.GetEnvironmentVariable("EventHubConnectionString");
        private readonly string _eventHubName = Environment.GetEnvironmentVariable("EventHubName");
        private readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public async Task Run()
        {
            Console.Write("Downloading bus data...");
            var bd = await DownloadBusData();        
            Console.WriteLine("Done.");

            Console.Write("Sending to EventHub...");
            await SendToEventHub(bd);
            Console.WriteLine("Done.");

            await Task.Delay(10000);
        }

        private async Task<Feed> DownloadBusData()
        {
            var response = await _client.GetAsync(_busRealTimeFeedUrl);
            response.EnsureSuccessStatusCode();
            var responseString = await response.Content.ReadAsStringAsync();
            var feed = JsonConvert.DeserializeObject<Feed>(responseString);
            return feed;
        }

        private async Task SendToEventHub(Feed feed)
        {                        
            await using (var producerClient = new EventHubProducerClient(_connectionString, _eventHubName))
            {                
                using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();

                feed.Entities.ForEach(b =>
                {
                    var d = new JObject
                    {
                        ["Id"] = b.Id,
                        ["DirectionId"] = b.Vehicle.Trip.DirectionId,
                        ["RouteId"] = b.Vehicle.Trip.RouteId,
                        ["VehicleId"] = b.Vehicle.VehicleId.Id,
                        ["Position"] = new JObject
                        {
                            ["Latitude"] = b.Vehicle.Position.Latitude,
                            ["Longitude"] = b.Vehicle.Position.Longitude
                        },
                        ["TimestampUTC"] = UnixEpoch.AddSeconds(b.Vehicle.Timestamp)
                    };
                    //Console.WriteLine(d.ToString(Formatting.None));
                    eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes(d.ToString(Formatting.None))));
                });

                await producerClient.SendAsync(eventBatch);              
                Console.Write($"{feed.Entities.Count} sent...");
            }
        }
    }
}
