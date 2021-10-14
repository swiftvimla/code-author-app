//
//  Notify.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2021-10-11.
//  Copyright © 2021 Jonatan Sundqvist. All rights reserved.
//

import Foundation

func bla() {
  let token = "af29zjjn8jszakjg9me2o69wue6h54"
  let user = "ut8ib5w6jjoxd34sm8yufhv6jubzos"
  guard let url = URL(string: "https://") else { return }
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  URLSession.shared.uploadTask(with: request, from: Data())
  //curl -s \
//   --form-string "token=\(token)" \
//   --form-string "user=\()" \
//   --form-string "message=___" \
}
