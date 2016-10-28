using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNVideoEditor
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNVideoEditorModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNVideoEditorModule"/>.
        /// </summary>
        internal RNVideoEditorModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNVideoEditor";
            }
        }
    }
}
