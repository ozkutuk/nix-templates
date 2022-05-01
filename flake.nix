{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      isabelle = {
        path = ./isabelle;
        description = "An Isabelle environment bundled with VSCodium";
      };

    };

    # defaultTemplate = self.templates.isabelle;

  };
}
