{ pkgs, vsPkgs, ... }:

let
  checkpatch-pl = "${pkgs.nur.repos.dmfrpro.checkpatch}";
in
{
  home.packages = with pkgs; [
    clang-tools
    checkpatch-pl
  ];

  programs.vscode.extensions = with vsPkgs; [
    ms-vscode.cpptools-extension-pack
    ms-vscode.makefile-tools
    ajshort.include-autocomplete
    ionutvmi.path-autocomplete
    idanp.checkpatch
  ];

  programs.vscode.profiles."default".userSettings = {
    # Default C/C++ formatter
    "editor.defaultFormatter" = "ms-vscode.cpptools-extension-pack";

    C_Cpp.formatting = "clangFormat";
    C_Cpp.clang_format_path = "${pkgs.clang-tools}/bin/clang-format";
    C_Cpp.clang_format_style = "file";

    # Fallback to Linux kernel clang-format style
    C_Cpp.clang_format_fallbackStyle = {
      AccessModifierOffset = -4;
      AlignAfterOpenBracket = "Align";
      AlignConsecutiveAssignments = false;
      AlignConsecutiveDeclarations = false;
      AlignEscapedNewlines = "Left";
      AlignOperands = true;
      AlignTrailingComments = false;
      AllowAllParametersOfDeclarationOnNextLine = false;
      AllowShortBlocksOnASingleLine = false;
      AllowShortCaseLabelsOnASingleLine = false;
      AllowShortFunctionsOnASingleLine = "None";
      AllowShortIfStatementsOnASingleLine = false;
      AllowShortLoopsOnASingleLine = false;
      AlwaysBreakAfterDefinitionReturnType = "None";
      AlwaysBreakAfterReturnType = "None";
      AlwaysBreakBeforeMultilineStrings = false;
      AlwaysBreakTemplateDeclarations = false;
      BinPackArguments = true;
      BinPackParameters = true;
      BraceWrapping = {
        AfterClass = false;
        AfterControlStatement = false;
        AfterEnum = false;
        AfterFunction = true;
        AfterNamespace = true;
        AfterObjCDeclaration = false;
        AfterStruct = false;
        AfterUnion = false;
        AfterExternBlock = false;
        BeforeCatch = false;
        BeforeElse = false;
        IndentBraces = false;
        SplitEmptyFunction = true;
        SplitEmptyRecord = true;
        SplitEmptyNamespace = true;
      };
      BreakBeforeBinaryOperators = "None";
      BreakBeforeBraces = "Custom";
      BreakBeforeInheritanceComma = false;
      BreakBeforeTernaryOperators = false;
      BreakConstructorInitializersBeforeComma = false;
      BreakConstructorInitializers = "BeforeComma";
      BreakAfterJavaFieldAnnotations = false;
      BreakStringLiterals = false;
      ColumnLimit = 80;
      CommentPragmas = "^ IWYU pragma:";
      CompactNamespaces = false;
      ConstructorInitializerAllOnOneLineOrOnePerLine = false;
      ConstructorInitializerIndentWidth = 8;
      ContinuationIndentWidth = 8;
      Cpp11BracedListStyle = false;
      DerivePointerAlignment = false;
      DisableFormat = false;
      ExperimentalAutoDetectBinPacking = false;
      FixNamespaceComments = false;
      IncludeBlocks = "Preserve";
      IncludeCategories = [
        {
          Regex = ".*";
          Priority = 1;
        }
      ];
      IncludeIsMainRegex = "(Test)?$";
      IndentCaseLabels = false;
      IndentGotoLabels = false;
      IndentPPDirectives = "None";
      IndentWidth = 8;
      IndentWrappedFunctionNames = false;
      JavaScriptQuotes = "Leave";
      JavaScriptWrapImports = true;
      KeepEmptyLinesAtTheStartOfBlocks = false;
      MacroBlockBegin = "";
      MacroBlockEnd = "";
      MaxEmptyLinesToKeep = 1;
      NamespaceIndentation = "None";
      ObjCBinPackProtocolList = "Auto";
      ObjCBlockIndentWidth = 8;
      ObjCSpaceAfterProperty = true;
      ObjCSpaceBeforeProtocolList = true;
      PenaltyBreakAssignment = 10;
      PenaltyBreakBeforeFirstCallParameter = 30;
      PenaltyBreakComment = 10;
      PenaltyBreakFirstLessLess = 0;
      PenaltyBreakString = 10;
      PenaltyExcessCharacter = 100;
      PenaltyReturnTypeOnItsOwnLine = 60;
      PointerAlignment = "Right";
      ReflowComments = false;
      SortIncludes = false;
      SortUsingDeclarations = false;
      SpaceAfterCStyleCast = false;
      SpaceAfterTemplateKeyword = true;
      SpaceBeforeAssignmentOperators = true;
      SpaceBeforeCtorInitializerColon = true;
      SpaceBeforeInheritanceColon = true;
      SpaceBeforeParens = "ControlStatementsExceptForEachMacros";
      SpaceBeforeRangeBasedForLoopColon = true;
      SpaceInEmptyParentheses = false;
      SpacesBeforeTrailingComments = 1;
      SpacesInAngles = false;
      SpacesInContainerLiterals = false;
      SpacesInCStyleCastParentheses = false;
      SpacesInParentheses = false;
      SpacesInSquareBrackets = false;
      Standard = "Cpp03";
      TabWidth = 8;
      UseTab = "Always";
    };

    C_Cpp.copilotHover = "disabled";
    C_Cpp.vcpkg.enabled = false;

    checkpatch.run = "onSave";
    checkpatch.checkpatchPath = "${checkpatch-pl}/bin/checkpatch.pl";
    checkpatch.diagnosticLevel = "Warning";

    "[c]" = {
      editor.tabSize = 8;
      editor.insertSpaces = false;
    };
    "[cpp]" = {
      editor.tabSize = 8;
      editor.insertSpaces = false;
    };
  };
}
