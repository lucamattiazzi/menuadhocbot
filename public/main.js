changeHref = () => {
  oldHref = document.getElementById("friends_token_link").href
  base = oldHref.split("friends").slice(0,1)
  newHref = base + "friends/" + document.getElementById("token").value
  document.getElementById("friends_token_link").href = newHref
}

deleteFriendship = () => {
  if(document.getElementsByClassName("friendship_list--table").length > 0){
    console.log('ok')
  }
}

upsideDown = (smile) =>{
  if(smile.innerHTML == ":("){
    smile.innerHTML = ":|"
  }else if(smile.innerHTML == ":|"){
    smile.innerHTML = ":)"
  }else if(smile.innerHTML == ":)"){
    smile.innerHTML = ":D"
  }else if(smile.innerHTML == ":D"){
    window.location.href = "/secrets";
  }
}
