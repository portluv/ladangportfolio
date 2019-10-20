after :firmtypes do
    firmtype = Firmtype.find_by_name('Education')
    firmtype.firm.create(name: 'Universitas Bina Nusantara', address: 'Jl. Raya Kb. Jeruk No.27, RT.1/RW.9, Kb. Jeruk, Kec. Kb. Jeruk, Kota Jakarta Barat, Jawa Barat 11530', profile_picture: '', home_picture: '', followers: 0)
end
