using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using TIME.Tools;
using TIME.Tools.ModelExecution;
using TIME.Tools.Optimisation;
using TIME.Tools.Persistence.DataMapping;

namespace CSIRO.TIME2R
{
    public class SimulationLoader
    {
        public static ITemporalSystemRunner LoadSystem(string filename)
        {
            checkIsNullOrEmpty(filename);
            var repo = new SystemSimulationXmlFilesRepository();
            var result = repo.Load(filename);
            return result;
        }
        
        public static IPointTimeSeriesSimulation LoadModel(string filename)
        {
            checkIsNullOrEmpty(filename);
            var repo = new SimulationXmlFilesRepository();
            var result = repo.Load(filename); 
            return result;
        }

        private static void checkIsNullOrEmpty(string filename)
        {
            if (string.IsNullOrEmpty(filename))
                throw new ArgumentException("Missing argument", "filename");
        }

        /// <summary>
        ///   Enables the fast execution.
        /// </summary>
        /// <param name="enabled"> if set to <c>true</c> [enabled]. </param>
        public static void EnableFastExecution(bool enabled = true)
        {
            ModelExecutionConfiguration.UseDynamicMethodAccessors = enabled;
            ModelRunner.DefaultUseFastSeriesIndexing = enabled;
            OptimiserModelConfiguration.DefaultModelRunnerFactory = new DefaultModelRunnerFactory(enabled);
        }

        public static IPointTimeSeriesSimulation CreateModelRunner(Type modelType)
        {
            return new ModelRunner(modelType);
        }
    }
}
