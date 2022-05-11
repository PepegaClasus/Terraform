#CodePipeline
resource "aws_codepipeline" "code_pipeline" {
  name     = "static-web-pipeline"
  role_arn = "arn:aws:iam::571653323309:role/service-role/pipelinerole"
  tags     = {
    Environment = var.env
  }

  artifact_store {
    location = "www.${var.bucket_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
        
      category = "Source"
      configuration = {
        BranchName           = var.repository_branch
        ConnectionArn        = var.github_connection
        FullRepositoryId     = var.repository_name
        OutputArtifactFormat = "CODE_ZIP"
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      run_order = 1
      version   = "1"
    }
  }
  

  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "BucketName" = "www.${var.bucket_name}"
        "Extract"    = "true"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "S3"
      run_order        = 1
      version          = "1"
    }
  }
}
