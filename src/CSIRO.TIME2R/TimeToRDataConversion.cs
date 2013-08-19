using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
//using CSIRO.Metaheuristics.RandomNumberGenerators;
//using CSIRO.Metaheuristics.Utils;
//using RDotNet;
using TIME.Core;
using TIME.DataTypes;
using TIME.Tools.Metaheuristics;
using TIME.Tools.Metaheuristics.Persistence;
using TIME.Tools.Metaheuristics.SystemConfigurations;
using TIME.Tools.ModelExecution;

namespace CSIRO.TIME2R
{
    // TODO: consider using extension methods on TimeSeries. But, this means implementing something like the clr import extension stuff... Tough?
    public class TimeToRDataConversion
    {
        private static void CheckEnvironmentVariables()
        {
            var searchPaths = (Environment.GetEnvironmentVariable("PATH") ?? "").Split(Path.PathSeparator);
            var pathsWithRdll = searchPaths.Where((x => File.Exists(Path.Combine(x, "R.dll"))));
            bool rdllInPath = (pathsWithRdll.Count() > 0);
            var rhome = (Environment.GetEnvironmentVariable("R_HOME") ?? "");
            if (!rdllInPath)
                throw new Exception("'R.dll' not found in any of the paths in environment variable PATH");
            if (string.IsNullOrEmpty(rhome))
            {
                // It is OK: the call to Initialize on the REngine will set up R_HOME.
                //throw new Exception("environment variable R_HOME is not set");
            }
        }

        //public static IntPtr ToNumericVectorPtr(TimeSeries ts)
        //{
        //    return ToNumericVector(ts).DangerousGetHandle();
        //}

        //public static SimpleHyperCube CreateSimpleHyperCube(string[] variableNames, double[] min, double[] value, double[] max)
        //{
        //    var result = new SimpleHyperCube(variableNames);
        //    for (int i = 0; i < variableNames.Length; i++)
        //        result.SetMinMaxValue(variableNames[i], min[i], max[i], value[i]);
        //    return result;
        //}

        //public static SimpleHyperCube CreateTestHyperCube()
        //{
        //    return new SimpleHyperCube(new string[] { "a", "b" });
        //    string blah = "blah";
        //}

        //public static BasicRngFactory CreateBasicRngFactory()
        //{
        //    return new BasicRngFactory(0);
        //}
        //public static SceParameterDefinition CreateSceParameterDefinition()
        //{
        //    return new SceParameterDefinition();
        //}

        //public static MpiSysConfig CreateMpiSysConfig()
        //{
        //    return new MpiSysConfig();
        //}

        public static TimeSeries CreateTimeSeries()
        {
            return new TimeSeries(new DateTime(2000, 1, 1), TimeStep.Daily, new double[] { 1, 2, 3, 4, 3, 2, 1 });
        }

        //public static SimpleHyperCube CreateSimpleHyperCube(SimpleHyperCube template, double[] values)
        //{
        //    var result = template.Clone() as SimpleHyperCube;
        //    var varNames = result.GetVariableNames();
        //    for (int i = 0; i < varNames.Length; i++)
        //    {
        //        result.SetValue(varNames[i], values[i]);
        //    }
        //    return result;
        //}

        public static TestObject CreateTestObject(string[] names)
        {
            return new TestObject(names);
        }

        public static void ApplyConfiguration(IPointTimeSeriesSimulation simulation, string sexpression)
        {
            var dataFrame = engine.Evaluate(sexpression).AsDataFrame();
            SimpleHyperCube s = convert(dataFrame);
            s.ApplyConfiguration(simulation);
        }

        public static void QueryTypes(params object[] args)
        {
            foreach (object item in args)
            {
                Console.WriteLine(item.GetType().FullName);
            }
        }

        public static string GetParameters(IModel model)
        {
            var t = new TIMEModelParameterSet(model);
            return t.GetConfigurationDescription();
        }

        public static void ApplyParameter(object system, string paramName, double value)
        {
            SimpleHyperCube hc = new SimpleHyperCube(new string[] { paramName });
            hc.SetMinMaxValue(paramName, value, value, value);
            hc.ApplyConfiguration(system);
        }

        //public static SimpleHyperCube convert(DataFrame dataFrame)
        //{
        //    dynamic df = dataFrame;
        //    object[] colnames = Enumerable.ToArray(SymbolicExpressionExtension.AsVector(df.names));
        //    // TODO: a helper equivalent with R's %in% operator
        //    object[] tmp = Enumerable.ToArray(SymbolicExpressionExtension.AsVector(df.name));
        //    var varnames = Array.ConvertAll(tmp, x => (string)x);
        //    SimpleHyperCube s = new SimpleHyperCube(varnames);
        //    var rows = dataFrame.GetRows();
        //    foreach (var vn in varnames)
        //    {
        //        dynamic row = rows.First( x=> ((string)((dynamic)x).name == vn));
        //        s.SetMinMaxValue(vn, row.min, row.max, row.value);
        //    }
        //    return s;
        //}
    }
    public class TestObject
    {
        public TestObject() { }
        public TestObject(string[] names) { this.names = names; }
        public int blah;
        public string GetMsg() { return "blah"; }
        public string[] names { get; set; }
    }
}
