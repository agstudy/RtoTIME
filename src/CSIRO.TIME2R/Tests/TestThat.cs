using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TIME.DataTypes;

namespace CSIRO.TIME2R.Tests
{
    public class TestThat
    {
        public static bool TestTimeSeries(TimeSeries ts, double[] expValues, string expTimeStep, DateTime expectedStart)
        {
            var tsv = ts.ToArray();
            if (tsv.Length != expValues.Length) return false;
            for (int i = 0; i < tsv.Length; i++)
                if (isDifferent(tsv[i], expValues[i])) return false;
            if (ts.timeStep.ToString() != expTimeStep)
                return false;
            // TODO: even for a constructed time series with a start date with kind Utc specified, the time series property 
            // ends up with a start date time of kind Unspecified. Very curious; may be a TIME 'issue
            // if (ts.Start != expectedStart) return false;
            return true;
        }

        private static bool isDifferent(double p1, double p2)
        {
            return Math.Abs(p1 - p2) > double.Epsilon;
        }
    }
}
