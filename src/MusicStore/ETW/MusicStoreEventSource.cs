using System;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using System.Linq;
using System.Threading.Tasks;

namespace MusicStore
{
    public class MusicStoreEventSource : EventSource
    {
        private MusicStoreEventSource() { }

        public static readonly MusicStoreEventSource Log = new MusicStoreEventSource();

        public void EnteringMain()
        {
            WriteEvent(1, "Entering Main");
        }

        public void HostStarted()
        {
            WriteEvent(2, "Host has started");
        }
    }
}
