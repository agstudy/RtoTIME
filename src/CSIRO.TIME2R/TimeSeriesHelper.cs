using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using TIME.DataTypes;

namespace CSIRO.TIME2R
{
    public class TimeSeriesHelper
    {
        public static double GetRegularTimeStepLengthDays(TimeSeries ts)
        {
            var t = ts.timeStep as EvenTimeStep;
            if (t == null)
                return -1;
            return t.span.TotalDays;
        }

        public static TimeSeries CreateTimeSeries(double[] values, DateTime startDate, string timeStep)
        {
            return new TimeSeries(startDate, TimeStep.FromName(timeStep), values);
        }

        public static TimeSeries CreateDailyTimeSeries(double[] values, DateTime startDate)
        {
            return new TimeSeries(startDate, TimeStep.Daily, values);
        }

        public static string GetIsoDateTimeStringStart(TimeSeries timeSeries)
        {
            var d = timeSeries.Start;
            return d.ToString(IsoDateTime.DATE_WHITESPACE_TIME_FORMAT_TO_SECOND, CultureInfo.InvariantCulture);
        }
    }
}
