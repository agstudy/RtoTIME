using System;
using System.Collections.Generic;
using System.Text;
using TIME.Core;
using TIME.Tools.Optimisation;
using TIME.Tools.Persistence;

namespace CSIRO.TIME2R
{
    public class ParameterSetHelper
    {
        public static ParameterSet LoadParameterSet(string xmlFileName)
        {
            return InputOutputHelper.DeserializeFromXML<ParameterSet>(xmlFileName);
        }

        public static ParameterSet CreateFrom(Model model)
        {
            return new ParameterSet(model);
        }

        public static SimplePset PsetToDataFrame(ParameterSet pset)
        {
            return new SimplePset(pset);
        }

        public class SimplePset
        {
            public SimplePset(ParameterSet pset)
            {
                var pSecs = pset.sortedForOptimisation;
                for (int i = 0; i < pSecs.Length; i++)
                {
                    var p = pSecs[i];
                    names.Add(p.member.Name);
                    descriptions.Add(p.Name);
                    min.Add(p.min);
                    max.Add(p.max);
                    values.Add(p.Value);
                }
            }

            List<string> names = new List<string>();
            List<string> descriptions = new List<string>();
            List<double> values = new List<double>();
            List<double> min = new List<double>();
            List<double> max = new List<double>();
            
            public double[] Values { get { return values.ToArray(); } }
            public double[] Minima { get { return min.ToArray(); } }
            public double[] Maxima { get { return max.ToArray(); } }
            public string[] Name { get { return names.ToArray(); } }
            public string[] Description { get { return descriptions.ToArray(); } }
        }
    }
}
