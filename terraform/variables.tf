variable "prefix" {
  default = "port-app"
}

variable "ecr_image_port_app" {
  default     = "497805377012.dkr.ecr.us-east-1.amazonaws.com/porfolio-app-72kb-github-actions:51bfb612296c64181664972592296d5d1bfd67d3"
  description = "URI for image"
}

