#' @title AutoH2oMLClassifier
#'
#' @description AutoH2oMLClassifier is an automated H2O modeling framework with grid-tuning and model evaluation that runs a variety of steps. First, a stratified sampling (by the target variable) is done to create train and validation sets. Then, the function will run a random grid tune over N number of models and find which model is the best (a default model is always included in that set). Once the model is identified and built, several other outputs are generated: validation data with predictions, evaluation plot, evaluation metrics, variable importance, partial dependence calibration plots, and column names used in model fitting.
#'
#' @author Adrian Antico
#' @family Automated Supervised Learning - Binary Classification
#'
#' @param OutputSelection You can select what type of output you want returned. Choose from c("EvalMetrics", "PDFs", "Score_TrainData")
#' @param data This is your data set for training and testing your model
#' @param TrainOnFull Set to TRUE to train on full data
#' @param ValidationData This is your holdout data set used in modeling either refine your hyperparameters.
#' @param TestData This is your holdout data set. Catboost using both training and validation data in the training process so you should evaluate out of sample performance with this data set.
#' @param TargetColumnName Either supply the target column name OR the column number where the target is located (but not mixed types). Note that the target column needs to be a 0 | 1 numeric variable.
#' @param FeatureColNames Either supply the feature column names OR the column number where the target is located (but not mixed types)
#' @param ExcludeAlgos "DRF","GLM","XGBoost","GBM","DeepLearning" and "Stacke-dEnsemble"
#' @param eval_metric This is the metric used to identify best grid tuned model. Choose from "AUC" or "logloss"
#' @param CostMatrixWeights A vector with 4 elements c(True Positive Cost, False Negative Cost, False Positive Cost, True Negative Cost). Default c(1,0,0,1),
#' @param MaxMem Set the maximum amount of memory you'd like to dedicate to the model run. E.g. "32G"
#' @param NThreads Set the number of threads you want to dedicate to the model building
#' @param MaxModelsInGrid Number of models to test from grid options (1080 total possible options)
#' @param model_path A character string of your path file to where you want your output saved
#' @param metadata_path A character string of your path file to where you want your model evaluation output saved. If left NULL, all output will be saved to model_path.
#' @param ModelID A character string to name your model and output
#' @param NumOfParDepPlots Tell the function the number of partial dependence calibration plots you want to create.
#' @param ReturnModelObjects Set to TRUE to output all modeling objects (E.g. plots and evaluation metrics)
#' @param SaveModelObjects Set to TRUE to return all modeling objects to your environment
#' @param SaveInfoToPDF Set to TRUE to print model insights to PDF
#' @param IfSaveModel Set to "mojo" to save a mojo file, otherwise "standard" to save a regular H2O model object
#' @param H2OShutdown Set to TRUE to shutdown H2O after running the function
#' @param H2OStartUp Set to FALSE
#' @param DebugMode Set to TRUE to print out steps taken
#' @examples
#' \donttest{
#' # Create some dummy correlated data with numeric and categorical features
#' data <- RemixAutoML::FakeDataGenerator(
#'   Correlation = 0.85,
#'   N = 1000L,
#'   ID = 2L,
#'   ZIP = 0L,
#'   AddDate = FALSE,
#'   Classification = TRUE,
#'   MultiClass = FALSE)
#'
#' TestModel <- RemixAutoML::AutoH2oMLClassifier(
#'   OutputSelection = c("EvalMetrics", "PDFs", "Score_TrainData"),
#'   data,
#'   TrainOnFull = FALSE,
#'   ValidationData = NULL,
#'   TestData = NULL,
#'   TargetColumnName = "Adrian",
#'   FeatureColNames = names(data)[!names(data) %in% c("IDcol_1", "IDcol_2","Adrian")],
#'   ExcludeAlgos = NULL,
#'   eval_metric = "auc",
#'   CostMatrixWeights = c(1,0,0,1),
#'   MaxMem = {gc();paste0(as.character(floor(as.numeric(system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)) / 1000000)),"G")},
#'   NThreads = max(1, parallel::detectCores()-2),
#'   MaxModelsInGrid = 10,
#'   model_path = normalizePath("./"),
#'   metadata_path = normalizePath("./"),
#'   ModelID = "FirstModel",
#'   NumOfParDepPlots = 3,
#'   ReturnModelObjects = TRUE,
#'   SaveModelObjects = FALSE,
#'   SaveInfoToPDF = TRUE,
#'   IfSaveModel = "mojo",
#'   H2OShutdown = TRUE,
#'   H2OStartUp = TRUE,
#'   DebugMode = FALSE)
#' }
#' @return Saves to file and returned in list: VariableImportance.csv, Model, ValidationData.csv, EvalutionPlot.png, EvaluationMetrics.csv, ParDepPlots.R a named list of features with partial dependence calibration plots, GridCollect, and GridList
#' @export
AutoH2oMLClassifier <- function(OutputSelection = c("EvalMetrics", "PDFs", "Score_TrainData"),
                                data = NULL,
                                TrainOnFull = FALSE,
                                ValidationData = NULL,
                                TestData = NULL,
                                TargetColumnName = NULL,
                                FeatureColNames = NULL,
                                ExcludeAlgos = NULL,
                                eval_metric = "auc",
                                CostMatrixWeights = c(1,0,0,1),
                                MaxMem = {gc();paste0(as.character(floor(as.numeric(system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)) / 1000000)),"G")},
                                NThreads = max(1, parallel::detectCores()-2),
                                MaxModelsInGrid = 2,
                                model_path = NULL,
                                metadata_path = NULL,
                                ModelID = "FirstModel",
                                NumOfParDepPlots = 3,
                                ReturnModelObjects = TRUE,
                                SaveModelObjects = FALSE,
                                SaveInfoToPDF = TRUE,
                                IfSaveModel = "mojo",
                                H2OShutdown = TRUE,
                                H2OStartUp = TRUE,
                                DebugMode = FALSE) {

  # Check Arguments ----
  if(!(tolower(eval_metric) %chin% c("auc", "logloss"))) stop("eval_metric not in AUC, logloss")
  if(!is.null(model_path)) if(!is.character(model_path)) stop("model_path needs to be a character type")
  if(!is.null(metadata_path)) if(!is.character(metadata_path)) stop("metadata_path needs to be a character type")
  if(!is.character(ModelID) & !is.null(ModelID)) stop("ModelID needs to be a character type")
  if(NumOfParDepPlots < 0) stop("NumOfParDepPlots needs to be a positive number")
  if(!(ReturnModelObjects %in% c(TRUE, FALSE))) stop("ReturnModelObjects needs to be TRUE or FALSE")
  if(!(SaveModelObjects %in% c(TRUE, FALSE))) stop("SaveModelObjects needs to be TRUE or FALSE")
  if(!(tolower(eval_metric) == "auc")) eval_metric <- tolower(eval_metric) else eval_metric <- toupper(eval_metric)
  if(tolower(eval_metric) %chin% c("auc")) Decreasing <- TRUE else Decreasing <- FALSE

  # Grab all official parameters and their evaluated arguments
  ArgsList <- c(as.list(environment()))
  ArgsList[['data']] <- NULL
  ArgsList[['ValidationData']] <- NULL
  ArgsList[['TestData']] <- NULL
  if(SaveModelObjects) {
    if(!is.null(metadata_path)) {
      save(ArgsList, file = file.path(metadata_path, paste0(ModelID, "_ArgsList.Rdata")))
    } else if(!is.null(model_path)) {
      save(ArgsList, file = file.path(model_path, paste0(ModelID, "_ArgsList.Rdata")))
    }
  }

  # Data Prepare ----
  if(DebugMode) print("Data Prepare ----")
  Output <- H2ODataPrep(TargetType.="classifier", TargetColumnName.=TargetColumnName, data.=data, ValidationData.=ValidationData, TestData.=TestData, TrainOnFull.=TrainOnFull, FeatureColNames.=FeatureColNames, SaveModelObjects.=SaveModelObjects, model_path.=model_path, ModelID.=ModelID)
  TargetColumnName <- Output$TargetColumnName; Output$TargetColumnName <- NULL
  dataTrain <- Output$dataTrain; Output$dataTrain <- NULL
  dataTest <- Output$dataTest; Output$dataTest <- NULL
  TestData <- Output$TestData; Output$TestData <- NULL
  Names <- Output$Names; rm(Output)

  # Start Up H2O ----
  if(H2OStartUp) localHost <- h2o::h2o.init(nthreads = NThreads, max_mem_size = MaxMem, enable_assertions = FALSE)
  datatrain <- h2o::as.h2o(dataTrain)
  if(!TrainOnFull) datavalidate <- h2o::as.h2o(dataTest, use_datatable = TRUE) else datavalidate <- NULL
  if(!is.null(TestData)) datatest <- h2o::as.h2o(TestData, use_datatable = TRUE) else datatest <- NULL

  # Build Model ----
  if(DebugMode) print("Build Model ----")
  if(!h2o::h2o.xgboost.available()) exclude <- unique(c(ExcludeAlgos,"XGBoost"))
  if(!TrainOnFull) {
    base_model <- h2o::h2o.automl(
      x = FeatureColNames,
      y = TargetColumnName,
      training_frame = datatrain,
      validation_frame = datavalidate,
      nfolds = 2,
      stopping_metric = "AUTO",
      project_name = "winner",
      exclude_algos = ExcludeAlgos,
      sort_metric = "AUTO",
      max_models = 20L,
      seed = 1L)
    base_model <- base_model@leader
  } else {
    base_model <- h2o::h2o.automl(
      x = FeatureColNames,
      y = TargetColumnName,
      training_frame = datatrain,
      nfolds = 2,
      stopping_metric = "AUTO",
      project_name = "winner",
      exclude_algos = ExcludeAlgos,
      sort_metric = "AUTO",
      max_models = 20L,
      seed = 1L)
    base_model <- base_model@leader
  }

  # Save Final Model ----
  if(DebugMode) print("Save Final Model ----")
  H2OSaveModel(SaveModelObjects.=SaveModelObjects, IfSaveModel.=IfSaveModel, base_model.=base_model, model_path.=model_path, ModelID.=ModelID)

  # Score Train Data ----
  if(DebugMode) print("Score Final Test Data ----")
  if("score_traindata" %chin% tolower(OutputSelection) && !TrainOnFull) {
    Predict <- data.table::as.data.table(h2o::h2o.predict(object = base_model, newdata = datatrain))
  }

  # Create Train Validation Data ----
  if(DebugMode) print("Create Validation Data ----")
  if("score_traindata" %chin% tolower(OutputSelection) && !TrainOnFull) {
    Output <- H2OValidationData(Predict.=Predict, TestData.=NULL, dataTest.=NULL, dataTrain.=dataTrain, TrainOnFull.=TRUE, SaveModelObjects.=SaveModelObjects, metadata_path.=metadata_path, model_path.=model_path, ModelID.=ModelID, TransformNumericColumns.=NULL, TransformationResults.=NULL, TargetColumnName.=NULL, data.=NULL)
    TrainData <- Output$ValidationData; rm(Output)
  }

  # Score Validation Data ----
  Predict <- data.table::as.data.table(h2o::h2o.predict(object = base_model, newdata = if(!is.null(TestData)) datatest else if(!TrainOnFull) datavalidate else datatrain))
  data.table::set(Predict, j = "p0", value = NULL)

  # Create Validation Data ----
  Output <- H2OValidationData(Predict.=Predict, TestData.=TestData, dataTest.=dataTest, dataTrain.=dataTrain, TrainOnFull.=TrainOnFull, SaveModelObjects.=SaveModelObjects, metadata_path.=metadata_path, model_path.=model_path, ModelID.=ModelID, TransformNumericColumns.=NULL, TransformationResults.=NULL, TargetColumnName.=NULL, data.=NULL)
  ValidationData <- Output$ValidationData; rm(Output)

  # Variable Importance ----
  if(DebugMode) print("Variable Importance ----")
  VariableImportance <- H2OVariableImportance(TrainOnFull.=TrainOnFull, base_model.=base_model, SaveModelObjects.=SaveModelObjects, metadata_path.=metadata_path, model_path.=model_path, ModelID.=ModelID)

  # H2O Explain TrainData ----
  if(DebugMode) print("H2O Explain TrainData ----")
  ExplainList <- list()
  if("score_traindata" %chin% tolower(OutputSelection) && !TrainOnFull) {
    ExplainList[["Train_Explain"]] <- h2o::h2o.explain(base_model, newdata = datatrain)
  }

  # H2O Explain ValidationData ----
  if(DebugMode) print("H2O Explain ValidationData ----")
  if(!TrainOnFull) {
    ExplainList[["Test_Explain"]] <- h2o::h2o.explain(base_model, newdata = if(!is.null(TestData)) datatest else if(!is.null(ValidationData) && !TrainOnFull) datavalidate else datatrain)
  }

  # H2O Shutdown ----
  if(DebugMode) print("H2O Shutdown ----")
  if(H2OShutdown) h2o::h2o.shutdown(prompt = FALSE)

  # Generate EvaluationMetrics ----
  if(DebugMode) print("Running BinaryMetrics()")
  EvalMetricsList <- list()
  EvalMetrics2List <- list()
  if("evalmetrics" %chin% tolower(OutputSelection)) {
    if("score_traindata" %chin% tolower(OutputSelection) && !TrainOnFull) {
      EvalMetricsList[["TrainData"]] <- BinaryMetrics(ClassWeights.=NULL, CostMatrixWeights.=CostMatrixWeights, SaveModelObjects.=FALSE, ValidationData.=TrainData, TrainOnFull.=TrainOnFull, TargetColumnName.=TargetColumnName, ModelID.=ModelID, model_path.=model_path, metadata_path.=metadata_path, Method = "threshold")
      EvalMetrics2List[["TrainData"]] <- BinaryMetrics(ClassWeights.=NULL, CostMatrixWeights.=CostMatrixWeights, SaveModelObjects.=FALSE, ValidationData.=TrainData, TrainOnFull.=TrainOnFull, TargetColumnName.=TargetColumnName, ModelID.=ModelID, model_path.=model_path, metadata_path.=metadata_path, Method = "bins")
      if(SaveModelObjects) {
        if(!is.null(metadata_path)) {
          data.table::fwrite(EvalMetricsList[['TrainData']], file = file.path(metadata_path, paste0(ModelID, "_Test_EvaluationMetrics.csv")))
        } else if(!is.null(model_path)) {
          data.table::fwrite(EvalMetricsList[['TrainData']], file = file.path(model_path, paste0(ModelID, "_Test_EvaluationMetrics.csv")))
        }
      }
    }
    EvalMetricsList[["TestData"]] <- BinaryMetrics(ClassWeights.=NULL, CostMatrixWeights.=CostMatrixWeights, SaveModelObjects.=FALSE, ValidationData.=ValidationData, TrainOnFull.=TrainOnFull, TargetColumnName.=TargetColumnName, ModelID.=ModelID, model_path.=model_path, metadata_path.=metadata_path, Method = "threshold")
    EvalMetrics2List[["TestData"]] <- BinaryMetrics(ClassWeights.=NULL, CostMatrixWeights.=CostMatrixWeights, SaveModelObjects.=FALSE, ValidationData.=ValidationData, TrainOnFull.=TrainOnFull, TargetColumnName.=TargetColumnName, ModelID.=ModelID, model_path.=model_path, metadata_path.=metadata_path, Method = "bins")
    if(SaveModelObjects) {
      if(!is.null(metadata_path)) {
        data.table::fwrite(EvalMetricsList[['TestData']], file = file.path(metadata_path, paste0(ModelID, "_Test_EvaluationMetrics.csv")))
      } else if(!is.null(model_path)) {
        data.table::fwrite(EvalMetricsList[['TestData']], file = file.path(model_path, paste0(ModelID, "_Test_EvaluationMetrics.csv")))
      }
    }
  }

  # Send output to pdf ----
  if(DebugMode) print("Running CatBoostPDF()")
  if("pdfs" %chin% tolower(OutputSelection) && SaveModelObjects) {
    CatBoostPDF(ModelClass = "h2o", ModelType="classification", TrainOnFull.=TrainOnFull, SaveInfoToPDF.=SaveInfoToPDF, PlotList.=NULL, VariableImportance.=VariableImportance, EvalMetricsList.=EvalMetricsList, Interaction.=NULL, model_path.=model_path, metadata_path.=metadata_path)
  }

  # Return Objects ----
  if(DebugMode) print("Return Objects ----")
  if(ReturnModelObjects) {
    return(list(
      Model = base_model,
      TrainData = if(exists("TrainData") && !is.null(TrainData)) TrainData else NULL,
      TestData = if(exists("ValidationData") && !is.null(ValidationData)) ValidationData else NULL,
      H2OExplain = if(exists("ExplainList")) ExplainList else NULL,
      EvaluationMetrics = if(exists("EvalMetricsList")) EvalMetricsList else NULL,
      EvaluationMetrics2 = if(exists("EvalMetrics2List")) EvalMetrics2List else NULL,
      VariableImportance = if(exists("VariableImportance")) VariableImportance else NULL,
      ColNames = if(exists("Names")) Names else NULL))
  }
}
