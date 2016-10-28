# react-native-video-editor

## Getting started

`$ npm install react-native-video-editor --save`

### Mostly automatic installation

`$ react-native link react-native-video-editor`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-video-editor` and add `RNVideoEditor.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNVideoEditor.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNVideoEditorPackage;` to the imports at the top of the file
  - Add `new RNVideoEditorPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-video-editor'
  	project(':react-native-video-editor').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-video-editor/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-video-editor')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNVideoEditor.sln` in `node_modules/react-native-video-editor/windows/RNVideoEditor.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Cl.Json.RNVideoEditor;` to the usings at the top of the file
  - Add `new RNVideoEditorPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNVideoEditor from 'react-native-video-editor';

// TODO: What do with the module?
RNVideoEditor;
```
