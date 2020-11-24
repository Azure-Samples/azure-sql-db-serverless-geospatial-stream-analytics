using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Text.Json;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using DotNetEnv;

namespace GTFS_To_EH
{
    class Program
    {        
        static async Task Main()
        {
            DotNetEnv.Env.Load();

            var rm = new RealTimeManager();
            while (true)
            {
                await rm.Run();
            }
        }
    }
}
