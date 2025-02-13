#' @title AppsPlotting
#'
#' @description Simple shiny app for viewing time series plots with box plots or line plots. You can use up to 3 categorical variables to filter by and one additional variable to filter as a bonus. You'll need to have shiny, shinyWidgets, htmltools
#'
#' @author Adrian Antico
#' @family GUI
#'
#' @param AzureCredsFile Path to your credentials file
#' @param HeaderColor 'black', 'blue', 'purple', 'green', 'red', 'yellow'
#' @param AppWidth Width of boxes
#' @param GroupVarsBoxColor Choose from 'red', 'yellow', 'aqua', 'blue', 'light-blue', 'green', 'navy', 'teal', 'olive', 'lime', 'orange', 'fuchsia', 'purple', 'maroon', 'black'
#' @param VarsBoxColor Choose from 'red', 'yellow', 'aqua', 'blue', 'light-blue', 'green', 'navy', 'teal', 'olive', 'lime', 'orange', 'fuchsia', 'purple', 'maroon', 'black'
#' @param FilterBoxColor Choose from 'red', 'yellow', 'aqua', 'blue', 'light-blue', 'green', 'navy', 'teal', 'olive', 'lime', 'orange', 'fuchsia', 'purple', 'maroon', 'black'
#' @param PlotBoxColor Choose from 'red', 'yellow', 'aqua', 'blue', 'light-blue', 'green', 'navy', 'teal', 'olive', 'lime', 'orange', 'fuchsia', 'purple', 'maroon', 'black'
#' @param CreatePlotButtonColor Choose from 'default', 'primary', 'warning', 'danger', 'success', 'royal'
#' @param UpdatePlotButtonColor Choose from 'default', 'primary', 'warning', 'danger', 'success', 'royal'
#' @param ResetPlotButtonColor Choose from 'default', 'primary', 'warning', 'danger', 'success', 'royal'
#' @param H3Color Header colors 'darkblue'
#' @param H4Color Text below headers but not the input cells; 'blue2'
#' @param AppTextColor 'white'
#' @param Browser FALSE
#' @param Docker FALSE
#' @param DockerPathToData bla
#' @param UserName_Password_DT NULL. In order to enforce authentication, supply a data.table with columns 'UserName' which contains the names of your users and 'Password' which contains the acceptable passwords. E.g. data.table::data.table(UserName = c('Adrian Antico', 'Guest'), Password = c('Password1', 'Password2')). Case sensitivity applies.
#' @param RunMode = 'package', 'local'
#' @param PlotObjectHome NULL
#' @param Debug FALSE
#'
#' @examples
#' \dontrun{
#' # Pull Data
#' # data <- data.table::fread(system.file('tests/QA_DataSets/ThreeGroup-FC-Walmart-XREG3.csv', package = "RemixAutoML"))
#' # data[, Date := as.Date(Date)]
#'
#' # Run App
#' # RemixAutoML::AppsPlotting(
#' #   HeaderColor = 'black',
#' #   AppWidth = 12L,
#' #   LogoWidth = '1000px',
#' #   LogoHeight = '100px',
#' #   GroupVarsBoxColor = 'navy',
#' #   VarsBoxColor = 'purple',
#' #   FilterBoxColor = 'blue',
#' #   PlotBoxColor = 'aqua',
#' #   CreatePlotButtonColor = 'default',
#' #   UpdatePlotButtonColor = 'default',
#' #   ResetPlotButtonColor = 'default',
#' #   H3Color = 'darkblue',
#' #   H5Color = 'blue2',
#' #   AppTextColor = 'white',
#' #   Docker = FALSE,
#' #   Browser = FALSE,
#' #   UserName_Password_DT = NULL,
#' #   PlotObjectHome = NULL,
#' #   Debug = FALSE)
#' #
#' # Debug = TRUE
#' # HeaderColor = 'black'
#' # AppWidth = 12L
#' # LogoWidth = '1000px'
#' # LogoHeight = '100px'
#' # GroupVarsBoxColor = 'navy'
#' # VarsBoxColor = 'purple'
#' # FilterBoxColor = 'blue'
#' # PlotBoxColor = 'aqua'
#' # CreatePlotButtonColor = 'default'
#' # UpdatePlotButtonColor = 'default'
#' # ResetPlotButtonColor = 'default'
#' # H3Color = 'darkblue'
#' # H4Color = 'blue2'
#' # AppTextColor = 'white'
#' # Docker = FALSE
#' # Browser = FALSE
#' # UserName_Password_DT = NULL
#' # Debug = TRUE
#' }
#'
#' @export
AppsPlotting <- function(AzureCredsFile = NULL,
                         HeaderColor = 'blue',
                         AppWidth = 12L,
                         LogoWidth = '800px',
                         LogoHeight = '100px',
                         GroupVarsBoxColor = 'navy',
                         VarsBoxColor = 'purple',
                         FilterBoxColor = 'blue',
                         PlotBoxColor = 'aqua',
                         CreatePlotButtonColor = 'royal',
                         UpdatePlotButtonColor = 'default',
                         ResetPlotButtonColor = 'default',
                         H3Color = 'darkblue',
                         H4Color = 'darkblue',
                         AppTextColor = 'blue',
                         Browser = FALSE,
                         Docker = FALSE,
                         DockerPathToData = NULL,
                         UserName_Password_DT = NULL,
                         RunMode = 'package',
                         PlotObjectHome = NULL,
                         Debug = FALSE) {

  # Stop criteria
  if(is.null(PlotObjectHome)) stop('Cannot run at this time')

  # Pass args to shiny app
  shiny::shinyOptions(
    AzureCredsFile = AzureCredsFile,
    DockerPathToData = DockerPathToData,
    PlotObjectHome = PlotObjectHome,
    HeaderColor = HeaderColor,
    AppWidth = AppWidth,
    LogoWidth = LogoWidth,
    LogoHeight = LogoHeight,
    GroupVarsBoxColor = GroupVarsBoxColor,
    VarsBoxColor = VarsBoxColor,
    FilterBoxColor = FilterBoxColor,
    PlotBoxColor = PlotBoxColor,
    CreatePlotButtonColor = CreatePlotButtonColor,
    UpdatePlotButtonColor = UpdatePlotButtonColor,
    ResetPlotButtonColor = ResetPlotButtonColor,
    H3Color = H3Color,
    H4Color = H4Color,
    AppTextColor = AppTextColor,
    UserName_Password_DT = UserName_Password_DT,
    Debug = Debug)

  # Run shiny app
  if(RunMode == 'package') {
    if(!Docker) {
      shiny::shinyAppDir(appDir = system.file('shiny-apps', 'AutoInsights', package = 'RemixAutoML'))
    } else {
      shiny::runApp(appDir = system.file('shiny-apps', 'AutoInsights', package = 'RemixAutoML'), display.mode = "normal", launch.browser = TRUE)
    }
  } else {
    if(!Docker) {
      shiny::runApp(appDir = file.path("C:/Users/Bizon/Documents/GitHub/RemixAutoML/inst/shiny-apps/AutoInsights"), launch.browser = TRUE)
    } else {
      shiny::runApp(appDir = file.path("C:/Users/Bizon/Documents/GitHub/RemixAutoML/inst/shiny-apps/AutoInsights"), display.mode = "normal", launch.browser = TRUE)
    }
  }
}

#' @title RunRemixAutoML
#'
#' @description GUI for running RemixAutoML functions. Time series evaluation and forecasting, machine learning, etc.
#'
#' @author Adrian Antico
#'
#' @family GUI
#'
#' @export
RunRemixAutoML <- function(data = NULL, ModelOutput = NULL, TargetName = NULL, PredictName = NULL, DateName = NULL, Debug = FALSE) {

  # Pass args to shiny app
  shiny::shinyOptions(
    data = data,
    ModelOutput = ModelOutput,
    TargetName = TargetName,
    PredictName = PredictName,
    DateName = DateName,
    Debug = Debug)
  shiny::shinyAppDir(appDir = system.file('shiny-apps', 'PanelForecasting', package = 'RemixAutoML'))
  #shiny::runApp(appDir, display.mode = "normal", launch.browser = TRUE)
}

#' @title FeatureEngineering
#'
#' @description Feature Engineering Script
#'
#' @author Adrian Antico
#'
#' @family GUI
#'
#' @noRd
FeatureEngineering <- function() {
  source(file.path(system.file("shiny-apps", "myapp", package = "RemixAutoML"), "Feature_Engineering.R"))
}
