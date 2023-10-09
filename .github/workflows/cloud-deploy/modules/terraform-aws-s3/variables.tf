variable "name" {
  description = "A common name that used across resources in this module"
  type        = string
}

variable "s3_bucket_tiering" {
  description = "s3 bucket common tiering"
  type        = list(any)
  default     = [
    {
      versioning_enable = true
      expiration        = []

      current_ver_transitions = [
        {
          days          = 0
          storage_class = "INTELLIGENT_TIERING"
        }
      ]
      non_current_ver_transitions = []
      expiration                  = []
      non_current_ver_expiration  = []
      intelligent_tiering         = [
        {
          days        = 180
          access_tier = "ARCHIVE_ACCESS"
        },
        {
          days        = 360
          access_tier = "DEEP_ARCHIVE_ACCESS"
        }
      ]
    }
  ]
}

variable "tags" {
  description = "Tags resouces"
  type = map(string)
}