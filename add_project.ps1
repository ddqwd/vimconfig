## 指定 Microsoft.VisualStudio.OLE.Interop.dll 的路径
#$interopAssemblyPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\Microsoft.VisualStudio.OLE.Interop.dll"
#$interopAssemblyPath3= "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\Microsoft.VisualStudio.Interop.dll"
#$interopAssemblyPath1 = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\envdte80.dll"
#$interopAssemblyPath4 = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\VSLangProj.dll"
#$interopAssemblyPath2 = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\envdte.dll"
#
#
#$envDTEAssembly1 = [Reflection.Assembly]::LoadFrom($interopAssemblyPath1)
#$envDTEAssembly1
#
##gacutil.exe /i $interopAssemblyPath1
#
#$envDTEAssembly1
## 添加引用
#Add-Type -Path $interopAssemblyPath
#Add-Type -Path $interopAssemblyPath1
#Add-Type -Path $interopAssemblyPath2
#Add-Type -Path $interopAssemblyPath3
#Add-Type -Path $interopAssemblyPath4
#
$dtee = New-Object -ComObject VisualStudio.DTE.17.0
$dtee


$csharpCode = @'
using System;
using System.IO;
using EnvDTE;
using EnvDTE80;
using System.Collections.Generic;
using System.Linq;

public class SolutionCreator31
{
    public static void CreateSolution(string basePath ,string solutionPath, string solutionName)
    {
        string logFilePath = basePath + "\\log1.txt";

        try {
        using (StreamWriter writer = new StreamWriter(logFilePath, false))
        {
            writer.WriteLine("Create Solution , ReposPath : " + basePath + ", OuputPath is :" + solutionPath + "\\" + solutionName);
            // Create DTE2 object
            Type dteType = Type.GetTypeFromProgID("VisualStudio.DTE.17.0");
            if (dteType == null)
            {
                 writer.WriteLine("dteType is null ");
                throw new Exception("Failed to get DTE type.");
            }

            writer.WriteLine("cat CrateInstance");

            DTE2 dte = (DTE2)Activator.CreateInstance(dteType);

            writer.WriteLine("cat s to s2 ");
            // Cast the Solution to Solution2 for additional functionality
            Solution2 solution2 = (Solution2)dte.Solution;

            writer.WriteLine("creat solution");
            // Create a new solution
            solution2.Create(solutionPath, solutionName);

            string solutionFilePath = System.IO.Path.Combine(solutionPath, solutionName + ".sln");
            string[] repos = new[]
            {
                "ps-app-cae-prepost-base",
                "ps-app-cae-prepost-cadcmd",
                "ps-app-cae-prepost-caddata",
                "ps-app-cae-prepost-cadui",
                "ps-app-cae-prepost-caecmd",
                "ps-app-cae-prepost-caedata",
                "ps-app-cae-prepost-geom",
                "ps-app-cae-prepost-post",
                "ps-app-cae-prepost-psgui-data",
                "ps-app-cae-prepost-uicomponent",
                "ps-app-cae-render",
                "ps-app-cae-workbench",
                "ps-app-cae-workspace"
            };


            writer.WriteLine("handle repos");
            SolutionFolder solutionFolder;
            foreach (string repo in repos)
            {
                Project prj = solution2.AddSolutionFolder(repo);
                solutionFolder = (SolutionFolder)prj.Object;
                writer.WriteLine("handle repo : " + repo);

                string curRepo = basePath + "\\" + repo;
                string all_build = curRepo + "\\build\\msvs\\ALL_BUILD.vcxproj";
                string installProj = curRepo + "\\build\\msvs\\INSTALL.vcxproj";
                writer.WriteLine("add proj file : " + all_build);
                if(File.Exists(all_build)){
                    solutionFolder.AddFromFile(all_build);
                } else {
                    writer.WriteLine(all_build + " is not exist");
                    continue;
                }
                if(File.Exists(installProj)){
                    solutionFolder.AddFromFile(installProj);
                }else {
                    writer.WriteLine(installProj+ " is not exist");
                    continue;
                }

                List<string> excludedFilenames = new List<string>
                {
                    "ALL_BUILD.vcxproj",
                    "INSTALL.vcxproj",
                    "VCTargetsPath.vcxproj",
                    "CompilerIdCXX.vcxproj",
                };

                var vcxprojFiles = Directory.EnumerateFiles(curRepo, "*.vcxproj", SearchOption.AllDirectories)
                                         .Where(file => !excludedFilenames.Contains(Path.GetFileName(file)));
                writer.WriteLine("vcxprojFiles : " + vcxprojFiles);

                foreach (var filePath in vcxprojFiles)
                {
                    writer.WriteLine("Add file: " + filePath);
                    solutionFolder.AddFromFile(filePath);
                }
            }

            solution2.SaveAs(solutionFilePath);

            dte.Quit();
        }
        } catch (Exception ex) {
            File.AppendAllText(logFilePath, ex.Message);
            throw;
        }
    }
}
'@
$envDTEAssembly = [Reflection.Assembly]::LoadFrom("C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\envdte80.dll")
$envDTEAssembly1 = [Reflection.Assembly]::LoadFrom("C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\envdte.dll")
$envDTEAssembly2 = [Reflection.Assembly]::LoadFrom("C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\PublicAssemblies\Microsoft.VisualStudio.Interop.dll")
Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies $envDTEAssembly,$envDTEAssembly1,$envDTEAssembly2

$solutionPath = "D:\"
$solutionName = "s5"
$solu2 = [SolutionCreator31]::CreateSolution($PWD,$solutionPath, $solutionName)



