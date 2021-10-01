function mu_r = dc_bias_2_permeability(core_id,permData,H)

a = permData.a(core_id);
b = permData.b(core_id);
c = permData.c(core_id);

mu_r = 1/(a+b*H^c);

end