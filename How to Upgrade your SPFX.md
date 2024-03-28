#Why you need to upgrade the SharePoint framework
- Import new technologies or components
- Improve the reliability of project
- Solve project security problem

---

# How To

## Step1: Install Microsoft 365 CLI tool
**Prerequisites: ensure your node version >=16**

You can follow this [link](https://pnp.github.io/cli-microsoft365/cmd/docs) for more usages

```powershell
npm i -g @pnp/cli-microsoft365
```
## Step2: Use Microsoft 365 CLI export a upgrade-report
 The following command will output a upgrade-report for your project. The first parameter '**--toVersion**' is the target version, the second parameter '**-o**' means output ,you can decide the output type of report.(**json**, **text**, **csv**, **md**,**tour** are available to select)
```PowerShell
m365 spfx project upgrade --toVersion [your target version] -o tour
```

Then you will get one file in path: **.\\.tours\upgrade.tour**

## Step3: Install Code Tour extension in your VS Code

This tool will resolve your .tour file and make it more readable. Then you can according to the tour file to start upgrade your project step by step.

---

#Further Steps

> Q1：When I upgrade my SPFX step by step, I found lots of commands need to execute, is there any convince way?

>Answer: For execute commands in batch way, you could copy following code to your project, it will help you to export all the install commands and remove file commands to upgradeCommand.bat, then you can directly execute the bat file.

```javascript
const fs = require('fs');
const writeStream = fs.createWriteStream("upgradeCommand.bat");

 getcommands();

function getcommands(){
    const extractedContents = [];
    var regx=/\[`([^`]*)`\]/;
    var tourfile=fs.readFileSync('.tours/upgrade.tour');
    tourfile=JSON.parse(tourfile);
    tourfile.steps.forEach(step => {
        const matches = step.description.match(regx);
        if (matches) {
          matches.forEach(match => {
            const content = match.match(/`([^`]*)`/);
            // console.log(content)
            if(null==content){
            }else{
              extractedContents.push(content[0]);
            }
          });
        }
      });
      for( var i in extractedContents){
        extractedContents[i]=extractedContents[i].replace(/`/g,'');
        if(!extractedContents[i].includes("cat >"))
          writeStream.write("call "+extractedContents[i]+'\n');
        // console.log(extractedContents[i]);
      }
      console.log(extractedContents+'\n'+'done');
    }
```

**please note: this script cannot help you change project configurations intelligently, so you still need to go through the tour to change it manually.**

 
> Q2: I'm going through the OSS issue fix, is there a way to make it easier for me to work? 

> Answer: normally, you need to check your package info frequently, but the package dependency info is too mess to check, so I will provide one script to make this way easier. 
> note:

```javascript
const fs = require('fs');

const jsonData = JSON.parse(fs.readFileSync('./package-lock.json'))
const targetValue = "@microsoft/sp-http";
const filteredKeys = getKeysWithLineAndVersion(jsonData, targetValue, jsonData.lockfileVersion);

console.log("your package-lock.json version is ", jsonData.lockfileVersion)
console.log(filteredKeys);


function getKeysWithLineAndVersion(obj, targetKey, lockfileVersion) {
  let keysWithLineAndVersion = [];

  function traverse(obj, path = []) {

    for (const key in obj) {

      path.push(key);
      if (key === targetKey) {
        if (lockfileVersion == 3) {
          keysWithLineAndVersion.push({ key: key, line: path.join('.'), version: obj[key] });
        } else {
          if (obj[key] && typeof obj[key] === 'object' && 'version' in obj[key]) {
            keysWithLineAndVersion.push({ key: key, line: path.join('.'), version: obj[key]['version'] });
          }
        }

      }
      if (typeof obj[key] === 'object') {
        traverse(obj[key], [...path]);
      }
      path.pop();
    }
  }

  traverse(obj);

  return keysWithLineAndVersion;
}


  

  
  ```
**Note:**
The variable 'targetValue' is your target package you want to check , will return a json result contains package version and dependency path
```json
sample:
  input:targetValue="async"
  output:[ { key: 'async', line: 'dependencies.async', version: '2.6.4' } ]
```
