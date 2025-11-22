resource "aws_codepipeline" "terraform_web_app_pipeline" {
  name     = "terraform-web-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "terraform-web-app-bucket-640b7809167e"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "helloaman0508"
        Repo       = "terraform-infra"
        Branch     = "main"
        # OAuthToken =  add prsnl token  
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName = "terraform-web-app"
        EnvironmentName = "devm"
      }
    }
  }
}

